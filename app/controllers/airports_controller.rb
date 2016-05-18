class AirportsController < ApplicationController
  layout "map"

  def index
  end

  def map_data
    @airports = Airport.where(:state => "CA").where("iata !~ '[0-9]'")
  end
end
