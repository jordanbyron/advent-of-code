require_relative '../advent'
require 'json'

input = JSON.parse(@input)

sum = 0

Grabber = ->(data) {
  if data.is_a?(Array)
    data.each do |v|
      Grabber[v]
    end
  elsif data.is_a?(Hash)
    if data.values.none? {|v| v == 'red' }
      data.each {|v| Grabber[v] }
    end
  elsif data.is_a?(Integer)
    sum += data
  end
}

Grabber[input]

binding.pry
