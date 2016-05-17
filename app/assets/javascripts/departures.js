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
