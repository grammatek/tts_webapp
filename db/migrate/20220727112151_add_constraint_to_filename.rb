class AddConstraintToFilename < ActiveRecord::Migration[7.0]
  def up
    ProcessedFile.find_each do |processed_file|
      unless processed_file.name?
        processed_file.name = "test_file"
      end
    end
    change_column_null :processed_files, :name, false
  end
  def down
    remove_column :processed_files, :name
  end
end
