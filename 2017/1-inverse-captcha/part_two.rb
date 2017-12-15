require_relative '../../advent'

input = @load_input[__FILE__].to_i

ChristmasCaptchaTwo = -> (input) {
  values = input.to_s.chars.map(&:to_i)
  offset = values.length / 2

  values.each_with_index.inject(0) do |sum, (value, index)|
    next_value = values[(index + offset) % values.length]

    if next_value == value
      sum += value
    else
      sum
    end
  end
}

describe "Captcha" do
  it "works with example one" do
    ChristmasCaptchaTwo.call(1212).must_equal 6
  end

  it "works with example two" do
    ChristmasCaptchaTwo.call(1221).must_equal 0
  end

  it "works with example three" do
    ChristmasCaptchaTwo.call(123425).must_equal 4
  end

  it "works with example four" do
    ChristmasCaptchaTwo.call(123123).must_equal 12
  end

  it "works with example five" do
    ChristmasCaptchaTwo.call(12131415).must_equal 4
  end
end

puts "Part Two: #{ChristmasCaptchaTwo.call(input)}"
