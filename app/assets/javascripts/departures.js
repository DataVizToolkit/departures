// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js

function makeChordChart(route) {
  var width         = 720,
      height        = 720,
      outerRadius   = Math.min(width, height) / 2 - 30,
      innerRadius   = outerRadius - 24
      formatPercent = d3.format(".1%"),
      color         = d3.scale.category20();

  var arc = d3.svg.arc()
      .innerRadius(innerRadius)
      .outerRadius(outerRadius);

  var layout = d3.layout.chord()
      .padding(.04)
      .sortSubgroups(d3.descending)
      .sortChords(d3.ascending);

  var path = d3.svg.chord()
      .radius(innerRadius);

  var svg = d3.select("#chart").append("svg")
      .attr("width", width)
      .attr("height", height)
    .append("g")
      .attr("id", "circle")
      .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

  svg.append("circle")
      .attr("r", outerRadius);

  svg.append("text")
      .attr('class', 'chart_title')
      .attr("x", 0)
      .attr("y", -340)
      .attr("text-anchor", "middle")
      .style("font-size", "16px")
      .text("American Airlines City Pairs (1999)");

  d3.json(route, function(error, data) {
    var airports = data.airports;

    // Compute the chord layout.
    layout.matrix(data.matrix);

    // Add a group per origin.
    var group = svg.selectAll(".group")
        .data(layout.groups)
      .enter().append("g")
        .attr("class", "group")
        .on("mouseover", mouseover);

    // Add a mouseover title.
    group.append("title").text(function(d, i) {
      return airports[i] + ": " + formatPercent(d.value) + " of origins";
    });

    // Add the group arc.
    var groupPath = group.append("path")
        .attr("id", function(d, i) { return "group" + i; })
        .attr("d", arc)
        .style("fill", function(d, i) { return color(i); });

    // Add a text label.
    var groupText = group.append("text")
        .attr("x", 6)
        .attr("dy", 15);

    groupText.append("textPath")
        .attr("xlink:href", function(d, i) { return "#group" + i; })
        .text(function(d, i) { return airports[i]; });

    // Remove the labels that don't fit. :(
    groupText.filter(function(d, i) { return groupPath[0][i].getTotalLength() / 2 - 16 < this.getComputedTextLength(); })
        .remove();

    // Add the chords.
    var chord = svg.selectAll(".chord")
        .data(layout.chords)
      .enter().append("path")
        .attr("class", "chord")
        .style("fill", function(d) { return color(d.source.index); })
        .attr("d", path);

    // Add an elaborate mouseover title for each chord.
    chord.append("title").text(function(d) {
      return airports[d.source.index]
          + " → " + airports[d.target.index]
          + ": " + formatPercent(d.source.value)
          + "\n" + airports[d.target.index]
          + " → " + airports[d.source.index]
          + ": " + formatPercent(d.target.value);
    });
    function mouseover(d, i) {
      chord.classed("fade", function(p) {
        return p.source.index != i
            && p.target.index != i;
      });
    }
  });
}

function makeTimeline() {
  var margin = {top: 10, right: 0, bottom: 20, left: 0},
      width  = 960 - margin.left - margin.right,
      height = 300 - margin.top - margin.bottom;

  // Create a default datetime range for the axis
  var x = d3.time.scale.utc()
      .domain([new Date(1999, 0, 1), new Date(1999, 0, 2)])
      .range([0, width]);

  var xAxis = d3.svg.axis()
      .scale(x)
      .orient("bottom")
      .ticks(d3.time.hours)
      .tickSize(16, 0)
      .tickFormat(d3.time.format("%I %p"));

  // ** function to draw a curved line given 3 points
  var curved = d3.svg.line()
      .x(function(d) { return d.x; })
      .y(function(d) { return d.y; })
      .interpolate("cardinal")
      .tension(0);

  var svg = d3.select("body").append("svg")
      .attr("width", width + margin.left + margin.right)
      .attr("height", height + margin.top + margin.bottom)
    .append("g")
      .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  svg.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)
    .selectAll(".tick text")
      .style("text-anchor", "start")
      .attr("x", 6)
      .attr("y", 6);

  // ** add a focus variable for mouseover tooltip
  var focus = svg.append("g")
      .attr("class", "focus")
      .style("display", "none");
  focus.append("text")
      .attr("x", 9)
      .attr("dy", ".35em");

  // ** Add a title to the chart
  svg.append("text")
      .attr('class', 'chart_title')
      .attr("x", width/2)
      .attr("y", height/2)
      .attr("text-anchor", "middle")
      .style("font-size", "16px")
      .text("Southwest Airlines Tail Number N509 (1999-01-01)");

  d3.json('/departures/timeline_data?date=1999-01-01', function(error, data) {
    var data = data.data;
    var departures = data.filter(function(d) { return d.origin !== null });
    // reset the X axis to the correct day's hours
    var startDate = new Date(data[0].hourly);
    var endDate   = new Date(data[0].hourly);
    endDate.setDate(endDate.getDate() + 1);
    x.domain([startDate, endDate]);
    svg.select(".x.axis")
      .call(xAxis)
      .selectAll(".tick text")
        .style("text-anchor", "start")
        .attr("x", 6)
        .attr("y", 6);

    // Draw dots for the departures on the x-axis (timeline)
    svg.selectAll("dot")
        .data(departures)
      .enter().append("circle")
        .attr("r", 3.5)
        .attr("cx", function(d) { return x(new Date(d.departure_time)); })
        .attr("cy", function(d) { return height; });

    // ** draw curved lines from the departure time to the arrival time
    var curve = svg.selectAll("curves")
        .data(departures)
      .enter().append("path")
        .attr("d", function(d) {
          var departureTime = new Date(d.departure_time);
          var middleTime    = new Date(d.departure_time);
          var arrivalTime   = new Date(d.arrival_time);
          middleTime.setMinutes(departureTime.getMinutes() + +d.actual_elapsed_time/2)
          return curved([
            {x: x(departureTime), y: height},
            {x: x(middleTime), y: height - 15},
            {x: x(arrivalTime), y: height},
          ])
        })
        .on("mouseover", function() { focus.style("display", null); })
        .on("mouseout", function() { focus.style("display", "none"); })
        .on("mousemove", function(d) { mousemove(d) });

    // ** generate the text for the mouseover tooltip
    function mousemove(d) {
      var departureTime = new Date(d.departure_time);
      var x0            = x(departureTime);
      var y0            = height - 30;
      focus.attr("transform", "translate(" + x0 + "," + y0 + ")");
      focus.select("text").text(d.origin + " → " + d.dest);
    }
  });
}
