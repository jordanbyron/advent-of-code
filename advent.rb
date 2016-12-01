require 'minitest/autorun'
require 'pry'
require 'fileutils'

# I hate this ...
#
@load_input = -> (file) {
  return if file.nil?
  path = File.expand_path('../input.txt', file)
  @input = File.read(path) if File.exists?(file)
}
