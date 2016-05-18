// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js

function makeMap() {
  // initialize the map on the "map" div with a given center and zoom
  L.mapbox.accessToken = $('body').data('mapboxToken');
  var map = L.mapbox.map('map', 'mapbox.streets')
    .setView([39.045753, -76.641273], 9);

  L.mapbox.featureLayer('/airports/map_data.json').on('ready', function(e) {
    var clusterGroup = new L.MarkerClusterGroup({
      maxClusterRadius: 35,
    });
    e.target.eachLayer(function(layer) {
      clusterGroup.addLayer(layer);
    });
    map.addLayer(clusterGroup);

    // Add arc between BLH and CEC
    var blh = { x: -114.7168764, y: 33.61916278 }
    ,   cec = { x: -124.2365333, y: 41.78015722 }
    ,   generator = new arc.GreatCircle(blh, cec, { name: 'BLH to CEC'  })
    ,   line = generator.Arc(100, { offset: 10  });
    L.geoJson(line.json()).addTo(map);

    map.fitBounds(clusterGroup.getBounds());
  });
}
