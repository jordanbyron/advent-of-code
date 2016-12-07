class IpAddress
  IP_ADDRESS_REGEX = /(\w+|\[\w+\])/

  def initialize(raw_address)
    @raw_address = raw_address
    @parts       = raw_address.scan(IP_ADDRESS_REGEX).flatten
  end

  # Supernet sequences don't start with a bracket
  #
  def supernets
    @supernets ||= @parts.select {|s| s[0] != '[' }
  end

  # Hypernet sequences start with a bracket
  #
  def hypernets
    @hypernets ||= @parts.
      select {|s| s[0] == '[' }.
      map {|s| s.gsub(/\[\]/, '') }
  end

  def to_s
    @raw_address
  end
end
