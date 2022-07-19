
class FileProcessingJob < ApplicationJob
  queue_as :default

  def perform(file_id)
    @processed_file = ProcessedFile.find(file_id)
    filename = @processed_file.text_file.filename
    file_content = @processed_file.text_file.download
    complete_text = ensure_utf8(file_content)
    snippet = extract_snippet(complete_text)

    p "Processing file: #{filename}, snippet: #{snippet}"
    @processed_file.name = filename
    @processed_file.snippet = snippet
    @processed_file.save

  end

  private

  def ensure_utf8(text)
    text.bytes.pack("c*").force_encoding("UTF-8")
  end

  def extract_snippet(text)
    if text.length > 100
      snippet = text[0, 100]
    else
      snippet = text
    end
    snippet
  end
end
