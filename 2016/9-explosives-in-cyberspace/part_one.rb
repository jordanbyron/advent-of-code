require_relative '../../advent'

input = @load_input[__FILE__]

MARKER_REGEX = /\((?<characters>\d+)x(?<repeat>\d+)\)/

Decompressor = ->(compressed_string) {
  decompressed_string = ""
  s = StringScanner.new(compressed_string)

  until(s.eos?)
    match = s.scan_until(MARKER_REGEX)

    if s.matched?
      decompressed_string += match.gsub(s.matched, '')

      match_data = MARKER_REGEX.match(s.matched)

      characters = match_data[:characters].to_i.times.map do
        s.getch
      end.join

      decompressed_string += (characters * match_data[:repeat].to_i)
    else
      decompressed_string += s.rest
      s.terminate
    end
  end

  decompressed_string
}

describe 'Decompressor' do
  it 'passes through strings without markers' do
    Decompressor['ADVENT'].must_equal 'ADVENT'
  end

  it 'expands markers' do
    Decompressor['A(1x5)BC'].must_equal 'ABBBBBC'
  end

  it 'expands markers with multiple characters' do
    Decompressor['(3x3)XYZ'].must_equal 'XYZXYZXYZ'
  end

  it 'works with multiple markers' do
    Decompressor['A(2x2)BCD(2x2)EFG'].must_equal 'ABCBCDEFEFG'
  end

  it 'works with back to back markers' do
    Decompressor['(6x1)(1x3)A'].must_equal '(1x3)A'
  end

  it 'works with multiple back to back markers' do
    Decompressor['X(8x2)(3x3)ABCY'].must_equal 'X(3x3)ABC(3x3)ABCY'
  end
end

puts "Part One: #{Decompressor[input.strip].strip.length}"
