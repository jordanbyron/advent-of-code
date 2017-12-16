require_relative '../../advent'
require_relative './spreadsheet_checksum'

input = @load_input[__FILE__]

RowChecksum = -> (row) {
  values = row.split(/\s+/).map(&:to_i)

  # Get all combinations of two numbers and sort them in reverse order
  #
  combinations = values.combination(2).map {|a| a.sort.reverse }

  divisible_numbers = combinations.find {|x,y| x % y == 0 }

  divisible_numbers.first / divisible_numbers.last
}

describe RowChecksum do
  it "works with row one" do
    RowChecksum.call("5 9 2 8").must_equal(4)
  end

  it "works with row two" do
    RowChecksum.call("9 4 7 3").must_equal(3)
  end

  it "works with row three" do
    RowChecksum.call("3 8 6 5").must_equal(2)
  end
end

puts "Part Two: #{SpreadsheetChecksum.call(input)}"
