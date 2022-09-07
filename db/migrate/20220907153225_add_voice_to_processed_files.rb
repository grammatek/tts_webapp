class AddVoiceToProcessedFiles < ActiveRecord::Migration[7.0]
  def change
    add_column :processed_files, :voice, :string
  end
end
