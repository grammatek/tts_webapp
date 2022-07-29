class AddStatusToProcessedFiles < ActiveRecord::Migration[7.0]
  def change
    add_column :processed_files, :status, :integer
  end
end
