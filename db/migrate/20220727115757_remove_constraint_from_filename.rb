class RemoveConstraintFromFilename < ActiveRecord::Migration[7.0]
  def change
    change_column_null :processed_files, :name, true
  end
end
