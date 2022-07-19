require 'json'
require 'faraday'

class TtsService < ApplicationService

@@tts_url = 'http://127.0.0.1:8000/v0/speech'
# max chars allowed in input text (for now)
@@max_chars = 10000

  def initialize(text, format)
    text4json = preprocess(text)
    if valid?(text4json)
      @request_data = init_request_data(text, format)
    end
  end

  def call
    p "===================== Calling TTS ======================="
    conn = Faraday.new(
      url: @@tts_url,
      headers: {'Content-Type' => 'application/json'}
    )
    response = conn.post('', @request_data)
    p "Successful? #{response.status}"
  end

private

  def init_request_data(text, format)
    {"Engine": "standard",
     "LanguageCode": "is-IS",
     "OutputFormat": "mp3",
     "SampleRate": "22050",
     "TextType": "#{format}",
     "VoiceId": "Alfur",
     "Text": "#{text}"}.to_json
  end

  def preprocess(text)
    oneline_text = text.gsub('\n', ' ')
    oneline_text = oneline_text.gsub('\t', ' ')
    oneline_text.gsub('"', '\"')
  end

  def valid?(text)
    if text.length > @@max_chars
      p "Input text is too long! Max #{@@max_chars} allowed in input file!"
      return false
    end
    true
  end

end