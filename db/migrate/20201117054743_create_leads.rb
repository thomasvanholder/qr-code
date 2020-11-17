class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads do |t|
      t.string :name
      t.string :category
      t.string :address
      t.string :email
      t.string :source

      t.timestamps
    end
  end
end
