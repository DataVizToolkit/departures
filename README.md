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
  - Disjointed city pair chord diagram ([60c1d65](https://github.com/DataVizToolkit/departures/tree/ch06.6))
* Ch 7, "Time-Series Aggregates in Postgres"
  - Timeline ([a2ff1a9](https://github.com/DataVizToolkit/departures/tree/ch07.1))
  - Fancy timeline ([6c57f36](https://github.com/DataVizToolkit/departures/tree/ch07.2))
* Ch 8, "Using a Separate Reporting Database"
  - Create reporting schema ([7f14609](https://github.com/DataVizToolkit/departures/tree/ch08.1))
  - Scenic gem and materialized view ([d7168b7](https://github.com/DataVizToolkit/departures/tree/ch08.2))
  - Bulk insert into table in reporting schema ([364840a](https://github.com/DataVizToolkit/departures/tree/ch08.3))
* Ch 9, "Working with Geospatial Data in Rails"
  - Add PostGIS to departures app ([ff68f47](https://github.com/DataVizToolkit/departures/tree/ch09.1))
  - Shapefile import, upsert airports, update `lonlat` ([9a07894](https://github.com/DataVizToolkit/departures/tree/ch09.2))
* Ch 10, "Making Maps with Leaflet and Rails"
  - Map California airports ([0ee6ad5](https://github.com/DataVizToolkit/departures/tree/ch10.1))
  - Airport marker clusters ([fe86219](https://github.com/DataVizToolkit/departures/tree/ch10.2))
  - Flight path from CEC to BLH ([7ec7ef5](https://github.com/DataVizToolkit/departures/tree/ch10.3))
* Ch 11, "Querying Geospatial Data"
  - Find items near a point scope ([2523a49](https://github.com/DataVizToolkit/departures/tree/ch11.1))
