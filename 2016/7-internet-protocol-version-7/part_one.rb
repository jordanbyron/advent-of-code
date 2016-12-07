require_relative '../../advent'
require_relative './ip_address'

input = @load_input[__FILE__]

IPSupportsTLS = ->(ip_address) {
  ip_address = IpAddress.new(ip_address)

  if ip_address.hypernets.any? {|ip_part| HasABBA[ip_part] }
    return false
  elsif ip_address.supernets.any? {|ip_part| HasABBA[ip_part] }
    return true
  else
    false
  end
}

# four-character sequence which consists of a pair of two different characters
# followed by the reverse of that pair
#
HasABBA = ->(input) {
  chars = input.chars
  chars.length.times.any? do |index|
    front = chars[index..(index + 1)]
    back  = chars[(index + 2)..(index + 3)]

    return false if front.nil? || front.empty? || back.nil? || back.empty?

    front == back.reverse && front[0] != back[0]
  end
}

describe 'HasABBA' do
  it 'returns true if the string contains an ABBA sequence' do
    HasABBA['abba'].must_equal true
  end

  it 'returns false if the string does not contain an ABBA sequence' do
    HasABBA['abcd'].must_equal false
  end

  it 'returns false when interior characters are the same' do
    HasABBA['aaaa'].must_equal false
  end
end

describe 'IPSupportsTLS' do
  it 'works with example one' do
    IPSupportsTLS['abba[mnop]qrst'].must_equal true
  end

  it 'works with example two' do
    IPSupportsTLS['abcd[bddb]xyyx'].must_equal false
  end

  it 'works with example three' do
    IPSupportsTLS['aaaa[qwer]tyui'].must_equal false
  end

  it 'works with example four' do
    IPSupportsTLS['ioxxoj[asdfgh]zxcvbn'].must_equal true
  end
end

ip_addresses = input.split("\n").map(&:strip)

part_one = ip_addresses.count {|ip_address| IPSupportsTLS[ip_address] }

puts "Part One: #{part_one}"
