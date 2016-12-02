require_relative '../../advent'

input = @load_input[__FILE__]
keypad = [
  [1,2,3],
  [4,5,6],
  [7,8,9]
]

DIRECTIONS = {
  'U' => [-1, 0],
  'D' => [1, 0],
  'L' => [0, -1],
  'R' => [0, 1]
}

InstructionParser = ->(instructions) {
  instructions.split("\n").map(&:chars)
}

IndexOfKey = ->(key, keypad) {
  keypad.each_with_index do |row, row_index|
    row.each_with_index do |col, col_index|
      if col == key
        return [row_index, col_index]
      end
    end
  end
}

KeyOfIndex = -> (index, keypad) {
  row, column = index

  return nil if row < 0 || column < 0

  keypad[row] && keypad[row][column]
}

RowReader = -> (instructions, start_key, keypad) {
  key = start_key

  instructions.each do |direction|
    index = IndexOfKey[key, keypad]

    # Add direction offeset to current index
    #
    index   = DIRECTIONS[direction].zip(index).map {|d| d.reduce(:+) }

    next_key = KeyOfIndex[index, keypad]

    key = next_key if next_key
  end

  return key
}

InstructionReader = -> (instructions, start_key, keypad) {
  last_key = start_key

  keys = instructions.map do |row|
    last_key = RowReader[row, last_key, keypad]
  end

  keys.join
}

describe 'InstructionParser' do
  it 'splits input file by lines to get individual codes' do
    instructions = InstructionParser["ULUL\nRDRD"]

    instructions.must_equal [%w[U L U L], %w[R D R D]]
  end
end

describe 'IndexOfKey' do
  it 'returns the row / col index of the provided key' do
    IndexOfKey[5, keypad].must_equal [1,1]
    IndexOfKey[1, keypad].must_equal [0,0]
    IndexOfKey[9, keypad].must_equal [2,2]
  end
end


describe 'RowReader' do
  it 'works with the first row' do
    instructions = InstructionParser["ULL"].first
    code         = RowReader[instructions, 5, keypad]

    code.must_equal 1
  end

  it 'works with the second row' do
    instructions = InstructionParser["RRDDD"].first
    code         = RowReader[instructions, 1, keypad]

    code.must_equal 9
  end

  it 'works with the third row' do
    instructions = InstructionParser["LURDL"].first
    code         = RowReader[instructions, 9, keypad]

    code.must_equal 8
  end

  it 'works with the fourth row' do
    instructions = InstructionParser["UUUUD"].first
    code         = RowReader[instructions, 8, keypad]

    code.must_equal 5
  end
end

describe 'InstructionReader' do
  it 'works with the full example' do
    instructions = InstructionParser["ULL\nRRDDD\nLURDL\nUUUUD"]
    InstructionReader[instructions, 5, keypad].must_equal '1985'
  end
end

instructions = InstructionParser[input]
puts "Part One: #{InstructionReader[instructions, 5, keypad]}"
