require_relative '../advent'

LookAndSay = ->(input) {
  input  = input.to_s.chars

  input.chunk {|i| i }.map do |i|
    i.last.length.to_s + i.first
  end.join
}

describe 'LookAndSay' do
  it 'works with simple numbers' do
    LookAndSay[1].must_equal '11'
  end

  it 'works with repeating numbers' do
    LookAndSay[11].must_equal '21'
  end

  it 'works with more repeating numbers' do
    LookAndSay[1211].must_equal '111221'
  end

  it 'works with more and more repeating numbers' do
    LookAndSay[111221].must_equal '312211'
  end
end

input = 1113122113

result = 50.times.reduce(input) do |i|
  LookAndSay[i]
end

puts result.to_s.length
