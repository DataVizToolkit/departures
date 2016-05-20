# Flight Departures

This repository provides downloadable code 
for the book, "Data Visualization Toolkit"; see [DataVisualizationToolkit.com](http://www.datavisualizationtoolkit.com).

These example programs are licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.<br/>
<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png"/></a>

## To Run

This is a rails app that runs on Ruby 2.2.3.  Clone the repo and run:

* `bundle install`
* `bundle exec rake db:create db:migrate`

Then you can follow along with the book.

## Checkpoints

* Ch 6, "The Chord Diagram"
  - Initial setup ([5bf69e6](https://github.com/DataVizToolkit/departures/tree/ch06.1))
  - Import airports and carriers ([4d8f846](https://github.com/DataVizToolkit/departures/tree/ch06.2))
  - Import flight departures (uses git-lfs) ([abe5a4a](https://github.com/DataVizToolkit/departures/tree/ch06.3))
  - Add foreign keys to departures ([44d2064](https://github.com/DataVizToolkit/departures/tree/ch06.4))
  - Chord diagram ([d102024](https://github.com/DataVizToolkit/departures/tree/ch06.5))
  - Disjointed city pair chord diagram ([395c0b2](https://github.com/DataVizToolkit/departures/tree/ch06.6))
* Ch 7, "Time-Series Aggregates in Postgres"
  - Timeline ([214a527](https://github.com/DataVizToolkit/departures/tree/ch07.1))
  - Fancy timeline ([0476e59](https://github.com/DataVizToolkit/departures/tree/ch07.2))
* Ch 8, "Using a Separate Reporting Database"
  - Create reporting schema ([2875a85](https://github.com/DataVizToolkit/departures/tree/ch08.1))
  - Scenic gem and materialized view ([ff5567e](https://github.com/DataVizToolkit/departures/tree/ch08.2))
  - Bulk insert into table in reporting schema ([f90ff9b](https://github.com/DataVizToolkit/departures/tree/ch08.3))
* Ch 9, "Working with Geospatial Data in Rails"
  - Add PostGIS to departures app ([cd31475](https://github.com/DataVizToolkit/departures/tree/ch09.1))
  - Shapefile import, upsert airports, update `lonlat` ([acb23eb](https://github.com/DataVizToolkit/departures/tree/ch09.2))
* Ch 10, "Making Maps with Leaflet and Rails"
  - Map California airports ([5acab95](https://github.com/DataVizToolkit/departures/tree/ch10.1))
  - Airport marker clusters ([bd9288a](https://github.com/DataVizToolkit/departures/tree/ch10.2))
  - Flight path from CEC to BLH ([f3e5d9f](https://github.com/DataVizToolkit/departures/tree/ch10.3))
* Ch 11, "Querying Geospatial Data"
  - Find items near a point scope ([f0595b7](https://github.com/DataVizToolkit/departures/tree/ch11.1))
