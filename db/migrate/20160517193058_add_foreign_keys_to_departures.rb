class AddForeignKeysToDepartures < ActiveRecord::Migration
  def change
    add_foreign_key :departures, :carriers, :column => :unique_carrier, :primary_key => :code
    add_foreign_key :departures, :airports, :column => :origin, :primary_key => :iata
    add_foreign_key :departures, :airports, :column => :dest, :primary_key => :iata
  end
end
