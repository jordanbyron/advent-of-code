require_relative './part_one'

input = @load_input[__FILE__]

# Lifted from https://gist.github.com/matugm/db363c7131e6af27716c
#
Cipher = -> (input, shift = 1) {
  alphabet   = Array('a'..'z')
  encrypter  = Hash[alphabet.zip(alphabet.rotate(shift))]
  input.chars.map { |c| encrypter.fetch(c, " ") }.join
}

describe 'Cipher' do
  it 'decrypts room names' do
    room = RoomDecoder['qzmt-zixmtkozy-ivhz-343[aaa]']

    Cipher[room[:name], room[:sector]].must_equal 'very encrypted name'
  end
end

rooms       = input.split("\n").map {|room| RoomDecoder[room] }
valid_rooms = rooms.select {|room| RoomValidator[room] }

room = valid_rooms.find do |room|
  decrypted_name = Cipher[room[:name], room[:sector]]

  !!decrypted_name[/northpole object/i]
end

puts "Part Two: #{room[:sector]}"
