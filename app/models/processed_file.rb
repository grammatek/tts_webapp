class ProcessedFile < ApplicationRecord
  enum text_type: [:html, :text]
  has_one_attached :text_file
  has_one_attached :audio_file
  scope :ordered, -> { order(id: :desc) }

  #after_create_commit -> { broadcast_prepend_to "processed_files", partial: "processed_files/processed_file", locals: { processed_file: self }, target: "processed_files" }
  #after_create_commit -> { broadcast_prepend_to "processed_files"}
  #after_update_commit -> { broadcast_replace_to "single_processed_file", partial: "processed_files/processed_file", locals: { processed_file: self }, target: "processed_file_#{:id}" }
  after_create_commit -> { broadcast_prepend_to "processed_files" }
  after_update_commit -> { broadcast_replace_to "processed_files" }
end
