require_relative '../../advent'
require_relative './spreadsheet_checksum'

input = @load_input[__FILE__]

RowChecksum = -> (row) {
  values = row.split(/\s+/).map(&:to_i)

  values.max - values.min
}

SpreadsheetChecksum = ->(spreadsheet) {
  rows = spreadsheet.split("\n")

  rows.inject(0) {|sum, row| sum += RowChecksum.call(row) }
}

describe RowChecksum do
  it "works with row one" do
    RowChecksum.call("5 1 9 5").must_equal(8)
  end

  it "works with row two" do
    RowChecksum.call("7 5 3  ").must_equal(4)
  end

  it "works with row three" do
    RowChecksum.call("2 4 6 8").must_equal(6)
  end

  it "works with larger numbers" do
    RowChecksum.call("100 3 5040").must_equal(5037)
  end
end

describe SpreadsheetChecksum do
  it "sums up all the rows checksum values" do
    spreadsheet = "5 1 9 5\n7 5 3\n2 4 6 8"

    SpreadsheetChecksum.call(spreadsheet).must_equal(18)
  end
end

puts "Part One: #{SpreadsheetChecksum.call(input)}"
