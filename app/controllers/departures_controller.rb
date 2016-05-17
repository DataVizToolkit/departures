class DeparturesController < ApplicationController
  def index; end

  def departure_matrix
    airports, matrix = Departure.departure_matrix
    render :json => {
      :airports => airports,
      :matrix   => matrix
    }
  end
end
