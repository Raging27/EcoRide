class CreatePassengerBookings < ActiveRecord::Migration[7.2]
  def change
    create_table :passenger_bookings do |t|
      t.references :trip, null: false, foreign_key: true
      t.references :passenger, null: false, foreign_key: { to_table: :users }
      t.string :status

      t.timestamps
    end
  end
end
