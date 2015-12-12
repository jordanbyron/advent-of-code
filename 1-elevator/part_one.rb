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
  up   = input.scan(/\(/).length
  down = input.scan(/\)/).length

  up - down
}

describe 'Elevator' do
  it 'works' do
    examples.each do |input, floor|
      Elevator[input].must_equal floor
    end
  end
end

puts Elevator[input]
