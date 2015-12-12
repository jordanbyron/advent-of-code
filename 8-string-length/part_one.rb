require_relative '../advent'

string_code_length = 0
memory_length = 0

class StringLength
  def initialize(string)
    @string = string
  end

  attr_reader :string

  def length
    string_code_length - memory_length
  end

  def string_code_length
    @string_code_length ||= string.length
  end

  def memory_length
    @memory_length ||= eval("\"#{string[1..-2]}\"").length
  end

  def encoded_length
    string.inspect.length
  end
end

describe StringLength do
  it 'works with empty strings' do
    string = '""'

    sl = StringLength.new(string)

    sl.length.must_equal 2
    sl.string_code_length.must_equal 2
    sl.memory_length.must_equal 0
    sl.encoded_length.must_equal 6
  end

  it 'works with simple strings' do
    string = '"abc"'

    sl = StringLength.new(string)

    sl.length.must_equal 2
    sl.string_code_length.must_equal 5
    sl.memory_length.must_equal 3
    sl.encoded_length.must_equal 9
  end

  it 'works with escaped characters' do
    string = '"aaa\"aaa"'

    sl = StringLength.new(string)

    sl.length.must_equal 3
    sl.string_code_length.must_equal 10
    sl.memory_length.must_equal 7
    sl.encoded_length.must_equal 16
  end

  it 'works with hex strings' do
    string = '"\x27"'

    sl = StringLength.new(string)

    sl.string_code_length.must_equal 6
    sl.memory_length.must_equal 1
    sl.length.must_equal 5
    sl.encoded_length.must_equal 11
  end
end

result = @input.split("\n").inject(0) do |sum, string|
  sl = StringLength.new(string)
  sum + sl.encoded_length - sl.string_code_length
end

puts result
