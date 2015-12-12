# --- Day 5: Doesn't He Have Intern-Elves For This? ---
#
# Santa needs help figuring out which strings in his text file are naughty or
# nice.
#
# A nice string is one with all of the following properties:
#
# - It contains at least three vowels (aeiou only), like aei, xazegov, or
#   aeiouaeiouaeiou.
# - It contains at least one letter that appears twice in a row, like xx, abcdde
#   (dd), or aabbccdd (aa, bb, cc, or dd).
# - It does not contain the strings ab, cd, pq, or xy, even if they are part of
#   one of the other requirements.
#
# For example:
#
# - ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...)
#   a double letter (...dd...), and none of the disallowed substrings.
# - aaa is nice because it has at least three vowels and a double letter, even
#   though the letters used by different rules overlap.
# - jchzalrnumimnmhp is naughty because it has no double letter.
# - haegwjzuvuyypxyu is naughty because it contains the string xy.
# - dvszwmarrgswjxmb is naughty because it contains only one vowel.
#
# How many strings are nice?

require 'pry'
require 'minitest/autorun'
require 'minitest/spec'

strings      = File.read('input.txt').split("\n")
test_nice    = %w[ugknbfddgicrmopn aaa]
test_naughty = %w[jchzalrnumimnmhp haegwjzuvuyypxyu dvszwmarrgswjxmb]
nice         = []

class NiceString
  def initialize(string)
    @string = string
  end

  attr_reader :string

  def nice?
    three_vowels &&
    double_letter &&
    not_restricted
  end

  private

  def three_vowels
    string.scan(/[aeiou]/).count >= 3
  end

  def double_letter
    string.chars.group_by {|a| a }.
      select {|k,v| v.length >= 2 }.
      any? do |k,_|
        string.match(/#{k * 2}/)
      end
  end

  def not_restricted
    !/(ab|cd|pq|xy)/.match(string)
  end
end

describe 'Nice strings' do
  it 'are nice' do
    test_nice.each {|s| NiceString.new(s).nice?.must_equal(true) }
  end
end

describe 'Naughty strings' do
  test_naughty.each do |string|
    it string do
      NiceString.new(string).nice?.must_equal(false)
    end
  end
end
