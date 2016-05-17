class CreateJuneDepartures < ActiveRecord::Migration
  def change
    create_view "reporting.june_departures", materialized: true
    add_index "reporting.june_departures", :tail_num
    add_index "reporting.june_departures", :origin
    add_index "reporting.june_departures", :dest
    add_index "reporting.june_departures", :unique_carrier
    add_index "reporting.june_departures", [:dep_date, :dep_time]
  end
end
