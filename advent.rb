require 'minitest/autorun'
require 'pry'
require 'fileutils'

@input = File.read('input.txt') if File.exists?('input.txt')
