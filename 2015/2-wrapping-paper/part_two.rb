require_relative '../advent'

input = @input.split("\n").map do |line|
  line.split("x").map(&:to_i)
end

RibbonSizer = ->(l,w,h) {
  side_perimeter  = [l* 2 + w * 2, w * 2 + h * 2, h * 2 + l * 2]
  small_perimeter = side_perimeter.min

  small_perimeter + (l * w * h)
}

describe RibbonSizer do
  it 'calculates ribbon sizes' do
    l = 2
    w = 3
    h = 4

    RibbonSizer[l,w,h].must_equal 34
  end

  it 'rocks' do
    l = 1
    w = 1
    h = 10

    RibbonSizer[l,w,h].must_equal 14
  end
end

sum = input.inject(0) do |sum, (l, w, h)|
  sum + RibbonSizer[l, w, h]
end

puts sum
