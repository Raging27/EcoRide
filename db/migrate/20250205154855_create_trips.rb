class CreateTrips < ActiveRecord::Migration[7.2]
  def change
    create_table :trips do |t|
      t.references :driver, null: false, foreign_key: { to_table: :users }
      t.references :vehicle, null: false, foreign_key: true
      t.string :start_city
      t.string :end_city
      t.datetime :start_time
      t.datetime :end_time
      t.integer :price
      t.integer :seats_available
      t.string :status

      t.timestamps
    end
  end
end
