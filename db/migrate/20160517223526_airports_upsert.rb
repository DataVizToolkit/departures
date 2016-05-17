class AirportsUpsert < ActiveRecord::Migration
  def up
    sql = <<-SQL.strip_heredoc
      -- Begin by defining the airports from the shapefile that we might want to insert
      WITH shapefile_airports AS (
        SELECT iata, airpt_name, city, state, 'USA',
          latitude, longitude, NOW(), NOW()
        FROM shapefiles.airports
        WHERE iata <> 'NONE' AND cntl_twr = 'Y'
      )
      -- INSERT INTO SELECT FROM query
      INSERT INTO airports (
        iata, airport, city, state, country,
        lat, long, created_at, updated_at
      )
      SELECT * FROM shapefile_airports
      -- UPSERT!!
      ON CONFLICT (iata) DO UPDATE SET
        lat=EXCLUDED.lat,
        long=EXCLUDED.long,
        updated_at=NOW();
    SQL
    connection.execute(sql)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
