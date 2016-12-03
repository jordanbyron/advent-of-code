require_relative './part_one'

input = @load_input[__FILE__]

ColumnTriangleParser = ->(input) {
  # Flip rows / columns
  triangles = TriangleParser[input].transpose
  # Group in 3s
  triangles.map {|a| a.each_slice(3).to_a }.flatten(1)
}

describe 'ColumnTriangleParser' do
  it 'parses triangle data by columns' do
    triangles = ColumnTriangleParser[
      "101 301 501
       102 302 502
       103 303 503
       201 401 601
       202 402 602
       203 403 603"]

    triangles.must_equal [
      [101, 102, 103],
      [201, 202, 203],
      [301, 302, 303],
      [401, 402, 403],
      [501, 502, 503],
      [601, 602, 603]
    ]
  end
end

triangles = ColumnTriangleParser[input]

total_possible = triangles.count do |triangle|
  TriangleValidator[triangle]
end

puts "Part Two: #{total_possible}"
