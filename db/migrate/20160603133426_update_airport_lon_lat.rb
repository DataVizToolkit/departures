class UpdateAirportLonLat < ActiveRecord::Migration
  def up
    sql = <<-SQL.strip_heredoc
      UPDATE airports
      SET lonlat = ST_GeomFromText('POINT(' || long || ' ' || lat || ')',4326)
      WHERE lonlat IS NULL;
    SQL
    connection.execute(sql)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
