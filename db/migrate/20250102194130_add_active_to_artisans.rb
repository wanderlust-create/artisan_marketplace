class AddActiveToArtisans < ActiveRecord::Migration[7.0]
  def change
    add_column :artisans, :active, :boolean, default: true, null: false
  end
end
