class CreateAaDepartures < ActiveRecord::Migration
  def up
    sql = <<-SQL.strip_heredoc
      CREATE MATERIALIZED VIEW aa_departures AS (
        WITH base_query AS (
          SELECT id,
            unique_carrier,
            flight_num,
            tail_num,
            origin,
            dest,
            to_date((((year || '-'::text) || month) || '-'::text) || day_of_month, 'YYYY-MM-DD'::text) AS dep_date,
            dep_time,
            arr_time,
            actual_elapsed_time,
            dep_delay,
            arr_delay,
            diverted
           FROM departures
           WHERE unique_carrier = 'AA'
        )
        SELECT *,
          LEAD(origin) OVER (PARTITION BY tail_num ORDER BY tail_num, dep_date, dep_time) AS next_origin
        FROM base_query
      );
      CREATE INDEX ON aa_departures USING btree (origin);
      CREATE INDEX ON aa_departures USING btree (dest);
      CREATE INDEX ON aa_departures USING btree (next_origin;
    SQL
  end

  def down
    execute("DROP MATERIALIZED VIEW aa_departures;")
  end
end
