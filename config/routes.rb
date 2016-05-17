Rails.application.routes.draw do
  root 'departures#index'
  get 'departures/index'
  get 'departures/departure_matrix'

  get 'departures/disjointed'
  get 'departures/disjointed_matrix'
end
