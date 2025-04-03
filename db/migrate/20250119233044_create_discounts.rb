class CreateDiscounts < ActiveRecord::Migration[7.0]
  def change
    create_table :discounts do |t|
      t.references :product, null: false, foreign_key: true

      t.decimal :original_price, precision: 10, scale: 2, null: false
      t.decimal :discount_price, precision: 10, scale: 2, null: false
      t.decimal :percentage_off, precision: 5, scale: 2 # optional

      t.integer :discount_type, null: false # enum: fixed_price or percentage

      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
