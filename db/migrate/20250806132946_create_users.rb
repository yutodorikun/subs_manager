class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :google_id, null: false
      t.string :avatar_url

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :google_id, unique: true
  end
end
