class AddVisibleToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :visible, :boolean, default: true, null: false
  end
end
