# The FileProcessingJob manages the communication with the TTS-service. Extracts document content, sends it
# with the appropriate arguments to the service and rescues whatever errors might occur during the
# service call. Updates the ProcessedFile model either with an attached audio file (on success) or sets an
# error message (when something goes wrong)

class FileProcessingJob < ApplicationJob
  queue_as :default

  # max length (in characters) of a text snippet to be presented in the view
  @@max_snippet_length = 150

  def perform(file_id)
    # The core job, prepare a call to the TTS-service, call the service, and store the generated audio if successful,
    # manage error messages otherwise.
    begin
      @processed_file = ProcessedFile.find(file_id)
      complete_text = prepare_processed_file
      @processed_file.save!

      format = get_format(@processed_file.text_type)
      audio_file = call_tts(complete_text, format, @processed_file.name, @processed_file.duration_val.to_s,
                            @processed_file.voice)
      logger.info("Created audio file: #{audio_file}")

      @processed_file.audio_file.attach(io: File.open(audio_file), filename: File.basename(audio_file))
      FileUtils.rm_f(audio_file)

    rescue StandardError => e
      logger.info(e.inspect)
      @processed_file.error_message = extract_error_message(e)
      @processed_file.save!
    end
  end

  def prepare_processed_file
    # Extracts filename and the file content from the attached text-file; extracts the beginning of the
    # file content as a short snippet to present in the view. Returns the complete text to process
    filename = @processed_file.text_file.filename
    file_content = get_file_content(filename)
    complete_text = ensure_utf8(file_content)
    snippet = extract_snippet(complete_text)

    logger.info("Processing file: #{filename}, snippet: #{snippet}, type: #{@processed_file.text_type}")

    @processed_file.name = filename
    @processed_file.snippet = snippet
    complete_text
  end

  def get_file_content(filename)
    if filename.to_s.ends_with?('.pdf')
      file_content = extract_pdf(filename)
    else
      file_content = @processed_file.text_file.download
    end
    file_content
  end

  def call_tts(text, format, filename, duration, voice)
    # The TtsService.call() returns a path to an audio file on success
    begin
      TtsService.call(text, format, filename, duration, voice)
    rescue StandardError => e
      raise e
    end
  end

  private

  def ensure_utf8(text)
    text.bytes.pack("c*").force_encoding("UTF-8")
  end

  def extract_snippet(text)
    if text.length > @@max_snippet_length
      snippet = text[0, @@max_snippet_length] + '[...]'
    else
      snippet = text
    end
    snippet
  end

  def get_format(text_type)
    if text_type == 'pdf'
      text_type = 'text'
    end
    text_type
  end

  def extract_pdf(pdf_filename)
    reader = PDF::Reader.new(pdf_filename)
    content = []
    reader.pages.each do |page|
      content.append(page.text)
    end
    content.join(' ')
  end

=begin
# This is not working yet, Docx::Document.open() throws an exception, not able to close a 'nil' object.
  def extract_docx(docx_filename)
    p "======= Processing docx ... =========="
    doc = Docx::Document.open(docx_filename)
    p "======== Created a docx ... =========="
    content = []
    doc.paragraphs.each do |para|
      content.append(para)
    end
    content.join(' ')
    end
=end

  def extract_error_message(error_msg_obj)
    # Returns a user friendly error message in Icelandic, depending on the type of error
    # represented by error_msg_obj
    error_msg = error_msg_obj.inspect
    if error_msg.include?('Faraday::ConnectionFailed')
      extracted_msg = 'Villa: náði ekki sambandi við talgervilsþjón'
    elsif error_msg.include?('Faraday::ServerError')
      extracted_msg = 'Villa á vefþjóni (500 villa)'
    elsif error_msg.include?('Faraday::ClientError')
      extracted_msg = 'Villa í fyrirspurn (4xx villa)'
    elsif error_msg.include?('Input text is too long')
      extracted_msg = 'Villa: skjalið er of stórt, hámark 10KB leyfð'
    else
      extracted_msg = 'Villa kom upp í vinnslu'
    end
    logger.info(extracted_msg)
    extracted_msg
  end
end
