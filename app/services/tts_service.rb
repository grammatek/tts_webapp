require 'json'
require 'faraday'

class TtsService < ApplicationService

@@tts_url = 'http://127.0.0.1:8000/v0/speech'
# max chars allowed in input text (for now)
@@max_chars = 10000
@@tmp_audio_path = "./app/assets/audio/"

  def initialize(text, format, filename)
    text4json = preprocess(text)
    if valid?(text4json)
      @request_data = init_request_data(text, format)
      @audio_out = @@tmp_audio_path + filename + ".mp3"
    end
  end

  def call
    p "===================== Calling TTS ======================="
    conn = Faraday.new(
      url: @@tts_url,
      headers: {'Content-Type' => 'application/json'}
    )
    response = conn.post('', @request_data)
    write_audio(response)
    p "Successful? #{response.status}"
    @audio_out
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

  def write_audio(response)
    File.open(@audio_out, 'wb') do |f|
      f.write(response.body)
    end
  end

end