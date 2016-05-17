class CreateUaDepartures < ActiveRecord::Migration
  def change
    create_table 'reporting.ua_departures' do |t|
      t.string :unique_carrier, limit: 8
      t.integer :flight_num
      t.string :tail_num, limit: 8
      t.string :origin, limit: 3
      t.string :dest, limit: 3
      t.date :dep_date
      t.integer :dep_time
      t.integer :arr_time
      t.integer :actual_elapsed_time
      t.integer :dep_delay
      t.integer :arr_delay
      t.boolean :diverted
      t.string :next_origin, limit: 3

      t.timestamps null: false
    end
  end
end
