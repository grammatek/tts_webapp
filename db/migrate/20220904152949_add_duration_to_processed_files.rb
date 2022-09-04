class AddDurationToProcessedFiles < ActiveRecord::Migration[7.0]
  def change
    add_column :processed_files, :duration_val, :float
  end
end
