require_relative '../../advent'

input = @load_input[__FILE__]

RoomDecoder = ->(room) {
  match_data = /(?<name>\D+)-(?<sector>\d+)\[(?<checksum>\D+)\]/.match(room)

  {
    name:       match_data[:name],
    sector:     match_data[:sector].to_i,
    checksum:   match_data[:checksum]
  }
}

RoomValidator = -> (room) {
  name_chars = room[:name].gsub('-', '').chars

  grouped_chars = Hash[name_chars.group_by {|v| v }.map do |k,v|
    [k, v.count]
  end]

  sorted_chars = grouped_chars.sort_by {|k,v| [-v,k] }.map {|k,_| k }

  sorted_chars.take(5).join == room[:checksum]
}

describe 'RoomDecoder' do
  it 'breaks room strings into parsed hashes' do
    input = 'aaaaa-bbb-z-y-x-123[abxyz]'

    room = RoomDecoder[input]

    room[:name].must_equal 'aaaaa-bbb-z-y-x'
    room[:sector].must_equal 123
    room[:checksum].must_equal 'abxyz'
  end
end

describe 'RoomValidator' do
  it 'returns true for example 1' do
    room = RoomDecoder['aaaaa-bbb-z-y-x-123[abxyz]']

    RoomValidator[room].must_equal true
  end

  it 'returns true for example 2' do
    room = RoomDecoder['a-b-c-d-e-f-g-h-987[abcde]']

    RoomValidator[room].must_equal true
  end

  it 'returns true for example 3' do
    room = RoomDecoder['not-a-real-room-404[oarel]']

    RoomValidator[room].must_equal true
  end

  it 'returns true for example 4' do
    room = RoomDecoder['totally-real-room-200[decoy]']

    RoomValidator[room].must_equal false
  end
end

rooms = input.split("\n").map {|room| RoomDecoder[room] }

valid_rooms = rooms.select {|room| RoomValidator[room] }

puts "Part One: #{valid_rooms.inject(0) {|s, room| s += room[:sector] }}"
