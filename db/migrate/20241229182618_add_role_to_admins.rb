class AddRoleToAdmins < ActiveRecord::Migration[7.0]
  def change
    add_column :admins, :role, :integer, default: 0
  end
end
