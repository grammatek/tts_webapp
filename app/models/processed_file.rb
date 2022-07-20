class ProcessedFile < ApplicationRecord
  enum text_type: [:html, :text]
  has_one_attached :text_file
  has_one_attached :audio_file
end
