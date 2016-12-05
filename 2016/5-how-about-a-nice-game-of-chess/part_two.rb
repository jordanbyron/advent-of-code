require_relative '../../advent'
require 'digest'

input = 'ugkcyxxp'

class AdvancedPasswordDecryptor
  PASSWORD_LENGTH = 8

  def initialize(seed)
    @seed           = seed
    @password_chars = Array.new(PASSWORD_LENGTH)
    @index          = 0
  end

  def password
    @password ||= begin
      until(password_chars.all? {|c| !c.nil? }) do
        result = next_char

        if password_chars[result[:position]].nil?
          password_chars[result[:position]] = result[:character]
          puts to_s
        end
      end

      password_chars.join
    end
  end

  def to_s
    "<AdvancedPasswordDecryptor " +
      "password=#{password_chars.map {|c| c.nil? ? "_" : c }.join} " +
      "seed=#{seed} index=#{index}>"
  end

  private

  attr_reader :password_chars, :index, :seed

  def next_char
    hash = '111111'

    until(hash[0..4] == '00000' && hash[5][/[0-7]/]) do
      @index += 1

      index_input = "#{seed}#{index}"
      hash        = Digest::MD5.hexdigest(index_input)
    end

    {
      character: hash[6],
      position:  hash[5].to_i
    }
  end
end

=begin
Yup, this takes a while to run too ...

describe 'AdvancedPasswordDecryptor' do
  it 'works with the example' do
    decryptor = AdvancedPasswordDecryptor.new('abc')

    decryptor.password.must_equal '05ace8e3'
  end
end
=end

decryptor = AdvancedPasswordDecryptor.new(input)

puts "Part Two: #{decryptor.password}"
