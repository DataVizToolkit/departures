require 'matrix'

module DepartureMatrix
  def airports_matrix!(counts:, field1: "origin", field2: "dest")
    h_matrix = counts.each_with_object({}) do |record, hash|
      hash[record[field1]] ||= Hash.new(0)
      hash[record[field1]][record[field2]] = Integer(record["count"])
    end
    airports = h_matrix.keys.sort
    total    = Float(h_matrix.values.flat_map(&:values).sum)
    matrix   = Matrix.build(airports.count) do |row, column|
      origin = airports[row]
      dest   = airports[column]
      h_matrix.fetch(origin, {}).fetch(dest, 0) / total
    end
    [airports, matrix]
  end
end
