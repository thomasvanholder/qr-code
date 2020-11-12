class AddQrcodeToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :qr_code, :text
  end
end
