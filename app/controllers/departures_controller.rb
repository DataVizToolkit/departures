class DeparturesController < ApplicationController
  def index; end
  def departure_matrix
    airports, matrix = Departure.departure_matrix
    render :json => {
      :airports => airports,
      :matrix   => matrix
    }
  end

  def disjointed; end
  def disjointed_matrix
    airports, matrix = Departure.disjointed_matrix
    render :json => {
      :airports => airports,
      :matrix   => matrix
    }
  end
end
