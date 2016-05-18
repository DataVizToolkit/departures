Rails.application.routes.draw do
  root 'departures#index'
  get 'departures/index'
  get 'departures/departure_matrix'

  get 'departures/disjointed'
  get 'departures/disjointed_matrix'

  get 'departures/timeline'
  get 'departures/timeline_data'

  get 'airports/index'
  get 'airports/map_data', :defaults => { :format => 'json' }
end
