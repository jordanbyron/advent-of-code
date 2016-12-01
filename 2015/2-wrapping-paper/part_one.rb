require 'minitest/autorun'
require 'pry'

raw_input = File.read('input.txt')
input = raw_input.split("\n").map do |line|
  line.split("x").map(&:to_i)
end

WrappingPaperSizer = ->(l,w,h) {
  side_area  = [l*w, w*h, h*l]
  small_side = side_area.min

  side_area.inject(0) {|sum, n| sum + (n * 2) } + small_side
}

describe 'Wrapping Paper' do
  it 'works!' do
    l = 2
    w = 3
    h = 4

    WrappingPaperSizer[l, w, h].must_equal 58
  end

  it 'really well!' do
    l = 1
    w = 1
    h = 10

    WrappingPaperSizer[l, w, h].must_equal 43
  end

  it 'parses the input file' do
    input.first.must_equal [29, 13, 26]
  end
end

sum = input.inject(0) do |sum, (l, w, h)|
  sum + WrappingPaperSizer[l, w, h]
end

puts sum
