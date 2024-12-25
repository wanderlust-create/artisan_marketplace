class ChangeStatusToIntegerInInvoices < ActiveRecord::Migration[7.0]
  def up
    change_column :invoices, :status, :integer, using: 'status::integer', null: false, default: 0
  end

  def down
    change_column :invoices, :status, :string
  end
end
