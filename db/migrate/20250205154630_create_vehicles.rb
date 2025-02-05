class CreateVehicles < ActiveRecord::Migration[7.2]
  def change
    create_table :vehicles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :plate_number
      t.date :date_first_registration
      t.string :brand
      t.string :model
      t.string :color
      t.boolean :electric

      t.timestamps
    end
  end
end
