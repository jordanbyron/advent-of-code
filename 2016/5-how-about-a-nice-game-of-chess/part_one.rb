require_relative '../../advent'
require 'digest'

input = 'ugkcyxxp'

NextPasswordCharacter = ->(input, index = 0) {
  hash = '11111'

  while(hash[0..4] != '00000') do
    index += 1

    index_input = "#{input}#{index}"
    hash        = Digest::MD5.hexdigest(index_input)
  end

  {
    character: hash[5],
    index:     index
  }
}

EightCharacterPassword = -> (input) {
  password = []
  index    = 0

  until(password.length == 8) do
    result    = NextPasswordCharacter[input, index]
    index     = result[:index]
    password << result[:character]
  end

  password.join
}

=begin

These guys pass but are SLOW. Uncomment to run

describe 'NextPasswordCharacter' do
  it 'returns the 6th hash character when the hash starts with 5 zeros' do
    result = NextPasswordCharacter['abc']

    result[:character].must_equal '1'
    result[:index].must_equal     3231929
  end

  it 'correctly calculates the next character based on a new starting index' do
    result = NextPasswordCharacter['abc', 3231929]

    result[:character].must_equal '8'
    result[:index].must_equal     5017308
  end

  it 'Gets the whole password' do
    password   = []
    index = 0

    until(password.length == 8) do
      result = NextPasswordCharacter['abc', index]
      index = result[:index]
      password << result[:character]
    end

    password.join.must_equal '18f47a30'
  end
end

describe 'EightCharacterPassword' do
  it 'gets all those sweet, sweet passwords' do
    EightCharacterPassword['abc'].must_equal '18f47a30'
  end
end
=end

puts "Part One: #{EightCharacterPassword[input]}"
