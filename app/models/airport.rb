class Airport < ActiveRecord::Base
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
