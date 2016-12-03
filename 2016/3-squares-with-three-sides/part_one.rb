require_relative '../../advent'

input = @load_input[__FILE__]

TriangleParser = ->(input) {
  input.split("\n").map do |triangle|
    triangle.split(/\s+/).reject {|s| s.strip.empty? }.map(&:to_i)
  end
}

# Returns true if the triangle is possible
#
TriangleValidator = ->(triangle) {
  triangle.permutation.all? do |a,b,c|
    (a + b) > c
  end
}

describe 'TriangleParser' do
  it 'splits lines and sides' do
    TriangleParser["1 2 3\n77    11    99"].
      must_equal [[1,2,3],[77,11,99]]
  end
end

describe 'TriangleValidator' do
  it 'returns true for valid triangles' do
    TriangleValidator[[5, 10, 10]].must_equal true
  end
  it 'returns false for impossible triangles' do
    TriangleValidator[[5,10,25]].must_equal false
  end
end

triangles = TriangleParser[input]

total_possible = triangles.count do |triangle|
  TriangleValidator[triangle]
end

puts "Part One: #{total_possible}"
