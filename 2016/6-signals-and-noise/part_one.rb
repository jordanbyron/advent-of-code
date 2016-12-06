require_relative '../../advent'

input = @load_input[__FILE__]

SignalParser = ->(input) {
  input.split("\n").map do |line|
    line.strip.chars
  end
}

SignalReader = ->(input, sorting = ->(v) { -v }) {
  message = input.transpose.map do |row|
    grouped_chars = Hash[row.group_by {|v| v }.map do |k,v|
      [k, v.count]
    end]

    sorted_chars = grouped_chars.sort_by {|k,v| [sorting[v],k] }.map {|k,_| k }

    sorted_chars.first
  end

  message.join
}

example_input = %{eedadn
drvtee
eandsr
raavrd
atevrs
tsrnev
sdttsa
rasrtv
nssdts
ntnada
svetve
tesnvt
vntsnd
vrdear
dvrsen
enarar}

describe 'SignalParser' do
  it 'splits signal into rows and characters' do
    signal = SignalParser[example_input]

    signal.count.must_equal 16
    signal.all? {|row| row.count == 6 }.must_equal true
  end
end

describe 'SignalReader' do
  let(:signal) { SignalParser[example_input] }
  it 'decipers the signal through the noise' do
    SignalReader[signal].must_equal 'easter'
  end

  it 'can sort by any special method' do
    sorting = ->(v) { v }

    SignalReader[signal, sorting].must_equal 'advent'
  end
end

signal  = SignalParser[input]
message = SignalReader[signal]

puts "Part One: #{message}"

message = SignalReader[signal, ->(v) { v}]
puts "Part Two: #{message}"
