class Airport < ActiveRecord::Base
  scope :close_to, -> (lon, lat, distance_in_meters = 200 * 1609.34) {
    select(sanitize_sql_array([%{
      ST_Distance(
        lonlat,
        ST_GeomFromText('POINT(? ?)',4326)
      ) AS distance_meters,
      *
    }, lon, lat])).
    where([%{
      ST_DWithin(
        lonlat,
        ST_GeographyFromText('SRID=4326;POINT(? ?)'),
        ?
      )
    }, lon, lat, distance_in_meters]).
    order("1")
  }

  module Factories
    GEO = RGeo::Geographic.spherical_factory(:srid => 4326)
  end
  before_create :set_lonlat

  def longitude
    long
  end
  def latitude
    lat
  end
  def lonlat
    Factories::GEO.point(longitude, latitude)
  end

  private
  def set_lonlat
    self.lonlat = Factories::GEO.point(longitude, latitude)
  end
end
