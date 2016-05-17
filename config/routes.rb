Rails.application.routes.draw do
  root 'departures#index'
  get 'departures/index'
  get 'departures/departure_matrix'
end
