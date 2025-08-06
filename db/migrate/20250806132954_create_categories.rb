class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :color, null: false
      t.string :icon

      t.timestamps
    end
    add_index :categories, :name, unique: true
  end
end
