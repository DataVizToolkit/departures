class JuneDeparture < ActiveRecord::Base
  self.table_name = "reporting.june_departures"

  def self.refresh
    Scenic.database.refresh_materialized_view(table_name)
  end
end
