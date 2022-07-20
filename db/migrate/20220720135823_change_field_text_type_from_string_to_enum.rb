class ChangeFieldTextTypeFromStringToEnum < ActiveRecord::Migration[7.0]
  def change
    change_column :processed_files, :text_type, :integer
  end
end
