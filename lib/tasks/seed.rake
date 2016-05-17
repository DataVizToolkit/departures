require 'csv'
require 'db_sanitize'
include DBSanitize

CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end
CSV::Converters[:na_to_nil] = lambda do |field|
  field && field == "NA" ? nil : field
end

namespace :db do
  namespace :seed do
    desc "Import airport data"
    task :import_airports => :environment do
      if Airport.count == 0
        filename     = Rails.root.join('db', 'data_files', 'airports.csv')
        fixed_quotes = File.read(filename).gsub(/\\"/,'""')
        CSV.parse(fixed_quotes, :headers => true, :header_converters => :symbol, :converters => [:blank_to_nil]) do |row|
          Airport.create(row.to_hash)
        end
      end
    end

    desc "Import airline/carrier data"
    task :import_carriers => :environment do
      if Carrier.count == 0
        filename = Rails.root.join('db', 'data_files', 'carriers.csv')
        CSV.foreach(filename, :headers => true, :header_converters => :symbol) do |row|
          Carrier.create(row.to_hash)
        end
      end
    end

    desc "Import flight departures data"
    task :import_departures => :environment do
      if Departure.count == 0
        filename  = Rails.root.join('db', 'data_files', '1999.csv')
        timestamp = Time.now.to_s(:db)
        CSV.foreach(filename, :headers => true, :header_converters => :symbol, :converters => [:na_to_nil]) do |row|
          puts "#{$.} #{Time.now}" if $. % 10000 == 0
          data = {
            :year                => DBSanitize::integer(row[:year]),
            :month               => DBSanitize::integer(row[:month]),
            :day_of_month        => DBSanitize::integer(row[:dayofmonth]),
            :day_of_week         => DBSanitize::integer(row[:dayofweek]),
            :dep_time            => DBSanitize::integer(row[:deptime]),
            :crs_dep_time        => DBSanitize::integer(row[:crsdeptime]),
            :arr_time            => DBSanitize::integer(row[:arrtime]),
            :crs_arr_time        => DBSanitize::integer(row[:crsarrtime]),
            :unique_carrier      => DBSanitize::string(row[:uniquecarrier]),
            :flight_num          => DBSanitize::integer(row[:flightnum]),
            :tail_num            => DBSanitize::string(row[:tailnum]),
            :actual_elapsed_time => DBSanitize::integer(row[:actualelapsedtime]),
            :crs_elapsed_time    => DBSanitize::integer(row[:crselapsedtime]),
            :air_time            => DBSanitize::integer(row[:airtime]),
            :arr_delay           => DBSanitize::integer(row[:arrdelay]),
            :dep_delay           => DBSanitize::integer(row[:depdelay]),
            :origin              => DBSanitize::string(row[:origin]),
            :dest                => DBSanitize::string(row[:dest]),
            :distance            => DBSanitize::integer(row[:distance]),
            :taxi_in             => DBSanitize::integer(row[:taxiin]),
            :taxi_out            => DBSanitize::integer(row[:taxiout]),
            :cancelled           => DBSanitize::boolean(row[:cancelled]),
            :cancellation_code   => DBSanitize::string(row[:cancellationcode]),
            :diverted            => DBSanitize::boolean(row[:diverted]),
            :carrier_delay       => DBSanitize::integer(row[:carrierdelay]),
            :weather_delay       => DBSanitize::integer(row[:weatherdelay]),
            :nas_delay           => DBSanitize::integer(row[:nasdelay]),
            :security_delay      => DBSanitize::integer(row[:securitydelay]),
            :late_aircraft_delay => DBSanitize::integer(row[:lateaircraftdelay]),
            :created_at          => DBSanitize::string(timestamp),
            :updated_at          => DBSanitize::string(timestamp)
          }
          sql = "INSERT INTO departures (#{data.keys.join(',')}) VALUES (#{data.values.join(',')})"
          ActiveRecord::Base.connection.execute(sql)
        end
      end
    end
  end
end
