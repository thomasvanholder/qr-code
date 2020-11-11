class AddEmailToRestaurants < ActiveRecord::Migration[6.0]
  def change
    add_column :restaurants, :email, :string
  end
end
