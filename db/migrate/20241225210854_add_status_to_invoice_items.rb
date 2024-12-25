class AddStatusToInvoiceItems < ActiveRecord::Migration[7.0]
  def change
    add_column :invoice_items, :status, :integer, null: false, default: 0
  end
end
