require 'minitest/autorun'

input = File.read('input.txt')

examples = {
  '(())'    => 0,
  '()()'    => 0,
  '((('     => 3,
  '(()(()(' => 3,
  '())'     => -1
}

Elevator = ->(input) {
  floor = 0
  target = nil

  input.chars.each_with_index do |key, index|
    direction = key == '(' ? 1 : -1

    floor += direction

    if floor == -1
      raise index.inspect
    end
  end
}

describe 'Elevator' do
  it 'works' do
    examples.each do |input, floor|
      Elevator[input].must_equal floor
    end
  end
end

puts Elevator[input]
