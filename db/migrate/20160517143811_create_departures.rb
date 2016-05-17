class CreateDepartures < ActiveRecord::Migration
  def change
    create_table :departures do |t|
      t.integer :year
      t.integer :month
      t.integer :day_of_month
      t.integer :day_of_week
      t.integer :dep_time
      t.integer :crs_dep_time
      t.integer :arr_time
      t.integer :crs_arr_time
      t.string :unique_carrier, limit: 6
      t.integer :flight_num
      t.string :tail_num, limit: 8
      t.integer :actual_elapsed_time
      t.integer :crs_elapsed_time
      t.integer :air_time
      t.integer :arr_delay
      t.integer :dep_delay
      t.string :origin, limit: 3
      t.string :dest, limit: 3
      t.integer :distance
      t.integer :taxi_in
      t.integer :taxi_out
      t.boolean :cancelled
      t.string :cancellation_code, limit: 1
      t.boolean :diverted
      t.integer :carrier_delay
      t.integer :weather_delay
      t.integer :nas_delay
      t.integer :security_delay
      t.integer :late_aircraft_delay

      t.timestamps null: false
    end
    add_index :departures, :year
    add_index :departures, :unique_carrier
    add_index :departures, :origin
    add_index :departures, :dest
    add_index :departures, :cancelled
  end
end
