class CreateAlternativePlans < ActiveRecord::Migration[7.1]
  def change
    create_table :alternative_plans do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.string :billing_cycle, null: false
      t.text :features
      t.string :plan_type, null: false
      t.string :company
      t.string :service_url

      t.timestamps
    end
    
    add_index :alternative_plans, [:category_id, :plan_type]
  end
end
