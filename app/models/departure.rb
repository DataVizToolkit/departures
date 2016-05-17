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
end
