class ChangeStatusToIntegerInInvoices < ActiveRecord::Migration[7.0]
  def change
    change_column :invoices, :status, :integer, using: 'status::integer', null: false, default: 0
  end
end

