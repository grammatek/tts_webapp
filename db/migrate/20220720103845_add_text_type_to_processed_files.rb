class AddTextTypeToProcessedFiles < ActiveRecord::Migration[7.0]
  def change
    add_column :processed_files, :text_type, :string
  end
end
