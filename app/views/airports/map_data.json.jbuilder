json.type "FeatureCollection"
json.features @airports do |airport|
  json.type "Feature"
  json.properties do
    json.set! "marker-color", "#9932CC"
    json.set! "marker-symbol", "circle"
    json.set! "marker-size", "small"
    json.title "#{airport.airport.squish} (#{airport.iata})"
  end
  json.geometry do
    json.type "Point"
    json.coordinates [airport.longitude, airport.latitude]
  end
end
