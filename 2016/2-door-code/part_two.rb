require_relative './part_one'

input  = @load_input[__FILE__]
keypad = [
  [nil, nil, 1, nil, nil],
  [nil,  2,  3,  4,  nil],
  [ 5,   6,  7,  8,   9 ],
  [nil, 'A','B','C', nil],
  [nil, nil,'D',nil, nil]
]

describe 'RowReader part two' do
  it 'works with the first row' do
    instructions = InstructionParser["ULL"].first
    code         = RowReader[instructions, 5, keypad]

    code.must_equal 5
  end

  it 'works with the second row' do
    instructions = InstructionParser["RRDDD"].first
    code         = RowReader[instructions, 5, keypad]

    code.must_equal 'D'
  end

  it 'works with the third row' do
    instructions = InstructionParser["LURDL"].first
    code         = RowReader[instructions, 'D', keypad]

    code.must_equal 'B'
  end

  it 'works with the fourth row' do
    instructions = InstructionParser["UUUUD"].first
    code         = RowReader[instructions, 'B', keypad]

    code.must_equal 3
  end
end

instructions = InstructionParser[input]
puts "Part Two: #{InstructionReader[instructions, 5, keypad]}"
