class AddUniqueIndexToAdminsEmail < ActiveRecord::Migration[7.0]
  def change
    remove_index :admins, :email if index_exists?(:admins, :email) # Remove old index if it exists
    add_index :admins, 'LOWER(email)', unique: true, name: 'index_admins_on_lower_email'
  end
end
