require_relative '../../advent'

input = @load_input[__FILE__].to_i

ChristmasCaptcha = -> (input) {
  values = input.to_s.chars.map(&:to_i)

  values.each_with_index.inject(0) do |sum, (value, index)|
    next_value = values[(index + 1) % values.length]

    if next_value == value
      sum += value
    else
      sum
    end
  end
}

describe "Captcha" do
  it "works with example one" do
    ChristmasCaptcha.call(1122).must_equal 3
  end

  it "works with example two" do
    ChristmasCaptcha.call(1111).must_equal 4
  end

  it "works with example three" do
    ChristmasCaptcha.call(1234).must_equal 0
  end

  it "works with example four" do
    ChristmasCaptcha.call(91212129).must_equal 9
  end
end

puts "Part One: #{ChristmasCaptcha.call(input)}"
