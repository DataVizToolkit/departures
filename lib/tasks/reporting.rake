namespace :db do
  namespace :reporting do
    desc "Insert UA Departures into the reporting schema"
    task :insert_ua_departures => :environment do
      UPDATE_LIMIT = 250_000
      CONN         = ActiveRecord::Base.connection

      def timestamp
        Time.now.utc.iso8601
      end
      def batch(sql_lambda:, limit: UPDATE_LIMIT, offset: 0, count: 0)
        sql = sql_lambda.call(limit,offset)
        if (cmd_tuples = CONN.execute(sql).cmd_tuples) > 0
          count += cmd_tuples
          if count % (UPDATE_LIMIT*10) == 0
            print "\n#{timestamp} records so far: #{count} "
          else
            print "."
          end
          batch(
            :sql_lambda => sql_lambda,
            :limit      => limit,
            :offset     => offset+=limit,
            :count      => count
          )
        else
          puts "\n#{timestamp} Total records: #{count}"
        end
      end

      sql = lambda do |limit, offset|
        <<-SQL
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
              diverted,
              created_at,
              updated_at
             FROM departures
             WHERE unique_carrier = 'UA'
          ), ua_departures AS (
            SELECT *,
              lead(origin) OVER (PARTITION BY tail_num ORDER BY tail_num, dep_date, dep_time) AS next_origin
            FROM base_query
          )
          INSERT INTO reporting.ua_departures
          SELECT id, unique_carrier, flight_num, tail_num,
            origin, dest, dep_date, dep_time, arr_time,
            actual_elapsed_time, dep_delay, arr_delay,
            diverted, next_origin, created_at, updated_at
          FROM ua_departures
          LIMIT #{limit} OFFSET #{offset};
        SQL
      end

      batch(:sql_lambda => sql)
    end
  end
end
