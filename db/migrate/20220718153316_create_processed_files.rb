class CreateProcessedFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :processed_files do |t|
      t.string :name
      t.text :snippet

      t.timestamps
    end
  end
end
