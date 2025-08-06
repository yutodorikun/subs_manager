class CreateSubscriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :billing_cycle, null: false
      t.date :start_date, null: false
      t.string :payment_method
      t.boolean :is_active, default: true
      t.string :service_url
      t.text :notes

      t.timestamps
    end
    
    add_index :subscriptions, [:user_id, :name]
    add_index :subscriptions, :is_active
  end
end
