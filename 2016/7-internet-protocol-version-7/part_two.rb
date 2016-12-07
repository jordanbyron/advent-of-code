require_relative '../../advent'
require_relative './ip_address'

input = @load_input[__FILE__]

ABAFinder = ->(sequence) {
  chars = sequence.chars
  abas  = []

  chars.length.times do |index|
    a1 = chars[index]
    b  = chars[index + 1]
    a2 = chars[index + 2]

    if !a1.nil? && !b.nil? && !a2.nil? && a1 == a2 && b != a1
      abas << [a1,b,a2].join
    end
  end

  abas.uniq
}

SupportSSL = ->(ip_address) {
  ip_address = IpAddress.new(ip_address)

  supernet_sequences = ip_address.supernets.map {|s| ABAFinder[s] }.flatten
  hypernet_sequences = ip_address.hypernets.map {|s| ABAFinder[s] }.flatten

  supernet_sequences.any? do |aba|
    bab = [aba.chars[1], aba.chars[0], aba.chars[1]].join

    hypernet_sequences.include?(bab)
  end
}

describe 'ABAFinder' do
  it 'returns all ABA sequences' do
    ABAFinder['aba'].must_equal ['aba']
  end

  it 'returns an empty array when none are found' do
    ABAFinder['aaa'].must_equal []
  end

  it 'returns unique sequences' do
    ABAFinder['xyxxyx'].must_equal ['xyx']
  end
end

describe 'SupportSSL' do
  it 'works with example one' do
    SupportSSL['aba[bab]xyz'].must_equal true
  end

  it 'works with example two' do
    SupportSSL['xyx[xyx]xyx'].must_equal false
  end

  it 'works with example three' do
    SupportSSL['aaa[kek]eke'].must_equal true
  end

  it 'works with example four' do
    SupportSSL['zazbz[bzb]cdb'].must_equal true
  end
end

ip_addresses = input.split("\n").map(&:strip)

part_two = ip_addresses.count {|ip_address| SupportSSL[ip_address] }

puts "Part Two: #{part_two}"
