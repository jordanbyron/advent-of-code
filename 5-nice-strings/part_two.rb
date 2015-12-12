require 'pry'
require 'minitest/autorun'
require 'minitest/spec'

strings      = File.read('input.txt').split("\n")
test_nice    = %w[qjhvhtzxzqqjkmpb xxyxx]
test_naughty = %w[uurcxstgmygtbstg ieodomkazucvgmuy aaaxbx]
nice         = []

class NiceString
  def initialize(string)
    @string = string
  end

  attr_reader :string

  def nice?
    double_pair &&
    repeats_with_separator
  end

  private

  def double_pair
    chars = string.chars
    chars.each_with_index.any? do |x, i|
      y = chars[i + 1]
      return false if y.nil?
      string.scan(/#{x}#{y}/).length == 2
    end
  end

  def repeats_with_separator
    multiples.any? do |s|
      string.match(/#{s}.#{s}/)
    end
  end

  def multiples
    @multiples ||= string.chars.select do |a|
      string.scan(/#{a}/).length >= 2
    end
  end
end

s = strings.select do |string|
  NiceString.new(string).nice?
end

puts s.length

describe 'Nice strings' do
  test_nice.each do |s|
    it s do
      NiceString.new(s).nice?.must_equal(true)
    end
  end
end

describe 'Naughty strings' do
  test_naughty.each do |string|
    it string do
      NiceString.new(string).nice?.must_equal(false)
    end
  end
end

