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
      repeat     = match_data[:repeat].to_i

      characters = match_data[:characters].to_i.times.map do
        s.getch
      end.join

      if MARKER_REGEX.match(characters)
        decompressed_string += (Decompressor[characters] * repeat)
      else
        decompressed_string += (characters * repeat)
      end
    else
      decompressed_string += s.rest
      s.terminate
    end
  end

  decompressed_string
}

# Just like Decompressor but returns the length of the decompressed string
# rather than the full string itself. Useful when you are dealing with super
# large strings and you don't have a super computer
#
DecompressorCounter = ->(compressed_string) {
  count = 0
  s = StringScanner.new(compressed_string)

  until(s.eos?)
    match = s.scan_until(MARKER_REGEX)

    if s.matched?
      count += match.gsub(s.matched, '').length

      match_data = MARKER_REGEX.match(s.matched)
      repeat     = match_data[:repeat].to_i

      characters = match_data[:characters].to_i.times.map do
        s.getch
      end.join

      if MARKER_REGEX.match(characters)
        count += (Decompressor[characters] * repeat).length
      else
        count += (characters * repeat).length
      end
    else
      count += s.rest.length
      s.terminate
    end
  end

  count
}

describe 'Decompressor' do
  it 'works with example one' do
    Decompressor['(3x3)XYZ'].must_equal 'XYZXYZXYZ'
  end

  it 'works with example two' do
    Decompressor['X(8x2)(3x3)ABCY'].must_equal 'XABCABCABCABCABCABCY'
  end

  it 'works with example three' do
    Decompressor['(27x12)(20x12)(13x14)(7x10)(1x12)A'].
      must_equal 'A' * 241920
  end

  it 'works with example four' do
    Decompressor['(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN'].
      length.must_equal 445
  end

end

describe 'DecompressorCounter' do
  it 'counts the length of the decompressed string' do
    DecompressorCounter['(27x12)(20x12)(13x14)(7x10)(1x12)A'].
      must_equal 241920
  end
end

puts "Part Two: #{DecompressorCounter[input.strip]}"
