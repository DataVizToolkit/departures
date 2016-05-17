require 'csv'
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
  end
end
