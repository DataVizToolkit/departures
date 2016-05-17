require 'matrix'

module DepartureMatrix
  def airports_matrix!(counts:)
    h_matrix = counts.each_with_object({}) do |record, hash|
      hash[record["origin"]] ||= Hash.new(0)
      hash[record["origin"]][record["dest"]] = Integer(record["count"])
    end
    airports = h_matrix.keys.sort
    total    = h_matrix.values.flat_map(&:values).sum * 1.0
    matrix   = Matrix.build(airports.count) do |row, column|
      origin = airports[row]
      dest   = airports[column]
      h_matrix.fetch(origin, {}).fetch(dest, 0) / total
    end
    [airports, matrix]
  end
end
