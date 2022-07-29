class AddErrorMsgToProcessedFiles < ActiveRecord::Migration[7.0]
  def change
    add_column :processed_files, :error_message, :string
  end
end
