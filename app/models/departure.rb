class Departure < ActiveRecord::Base
  extend DepartureMatrix

  def self.departure_matrix
    sql = <<-SQL.strip_heredoc
      SELECT origin, dest, count(*)
      FROM departures
      WHERE unique_carrier = 'AA'
      GROUP BY 1, 2
      ORDER BY 1, 2
    SQL
    counts = connection.execute(sql)
    airports_matrix!(:counts => counts)
  end

  def self.timeline
    sql = <<-SQL.strip_heredoc
      WITH hours AS (
        SELECT *
        FROM generate_series(
            '1999-01-01 00:00'::timestamp,
            '1999-12-31 23:00'::timestamp,
            '1 hour') AS hourly
      ), flights AS (
        SELECT id, year, month, day_of_month, dep_time, arr_time,
          (year::text || LPAD(month::text, 2, '0') || LPAD(day_of_month::text, 2, '0') || ' ' || LPAD(dep_time::text, 4, '0'))::timestamp AS departure_time,
          (year::text || LPAD(month::text, 2, '0') || LPAD(day_of_month::text, 2, '0') || ' ' || LPAD(arr_time::text, 4, '0'))::timestamp AS arrival_time,
          flight_num, actual_elapsed_time, origin, dest, distance, tail_num
        FROM departures
        WHERE tail_num = 'N509'
        ORDER BY year, month, day_of_month, dep_time
      )
      SELECT ROW_NUMBER() OVER (ORDER BY hourly) AS row_id, hourly, id,
        departure_time, arrival_time, dep_time, arr_time, flight_num,
        actual_elapsed_time, origin, dest, distance, tail_num
      FROM flights
      RIGHT JOIN hours ON tsrange(hours.hourly, hours.hourly + '1 hour') @> departure_time
      WHERE tsrange('1999-01-01 00:00'::timestamp, '1999-01-01 23:59'::timestamp) @> hourly
    SQL
    counts = connection.execute(sql)
  end
end
