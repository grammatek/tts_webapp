require 'json'
require 'faraday'

# TTS-Service connects to an external TTS-service, sends a request and receives a response with generated speech
# if successful. On failure exceptions are raised and are expected to be rescued by the calling class.

class TtsService < ApplicationService
  # sdf
  # TODO: make configurable
  #@@tts_url = 'http://127.0.0.1:8000/v0/speech'

@@tts_url = 'https://api.grammatek.com/tts/v0/speech'

# max chars allowed in input text (for now)
@@max_chars = 10000
# a directory where the response audio is written to as .mp3
@@tmp_audio_path = "./app/assets/audio/"

  def initialize(text, format, filename)
    text4json = preprocess(text)
    if valid?(text4json)
      @request_data = init_request_data(text, format)
      @audio_out = @@tmp_audio_path + filename + ".mp3"
    else
      raise StandardError, "Input text is too long! Max #{@@max_chars} allowed in input file!"
    end
  end

  def call
    # Calls the external TTS-service and writes the audio response to @audio_out, if successful,
    # and returns @audio_out
    # Raises exception on failure.
    p "================= Calling TTS ====================="
    begin
      conn = Faraday.new(
        url: @@tts_url,
        headers: {'Content-Type' => 'application/json'}
      )
      response = conn.post('', @request_data)
      if response and response.status >= 500
        raise Faraday::ServerError.new('server error', response)
      end
      write_audio(response)
      p "Response status TTS-service: #{response.status}"
      @audio_out
    rescue Faraday::ConnectionFailed => e
      raise e
    rescue Faraday::ServerError => e
      raise e
    rescue Faraday::ClientError => e
      raise e
    end
  end

private

  def init_request_data(text, format)
    # The request data format as required by the currently used TTS-service.
    {"Engine": "standard",
     "LanguageCode": "is-IS",
     "OutputFormat": "mp3",
     "SampleRate": "22050",
     "TextType": "#{format}",
     "VoiceId": "Alfur",
     "Text": "#{text}"}.to_json
  end

  def preprocess(text)
    # The text in the request has to be json-conform, and it cannot contain new-lines or tabs.
    # Process the text accordingly before initializing the request.
    oneline_text = text.gsub('\n', ' ')
    oneline_text = oneline_text.gsub('\t', ' ')
    oneline_text.gsub('"', '\"')
  end

  def valid?(text)
    if text.length > @@max_chars
      return false
    end
    true
  end

  def write_audio(response)
    File.open(@audio_out, 'wb') do |f|
      f.write(response.body)
    end
  end

end