require_relative '../advent'
require 'csv'

seating_arrangements = CSV.read('part_two_arrangements.csv') # CSV.read('arrangements.csv')
people = seating_arrangements.first

HappinessParser = ->(input) {
  regex = /(?<person>\S+) would (?<action>(lose|gain)) (?<amount>\d+) happiness units by sitting next to (?<target>\w+)/

  rules = {}

  input.each do |rule|
    if data = regex.match(rule)
      rules[data[:person]] ||= {}

      amount = if data[:action] == 'gain'
        data[:amount].to_i
      elsif data[:action] == 'lose'
        - data[:amount].to_i
      else
        raise "Unknown action '#{data[:action]}'"
      end

      rules[data[:person]][data[:target]] = amount
    else
      raise "Unknown rule: '#{rule}'"
    end
  end

  rules
}

rules = HappinessParser[@input.split("\n")]

# Manually add Me to the rules for part two.
#
rules["Me"] = {}

(people - ["Me"]).each do |person|
  rules["Me"][person] = 0
  rules[person]["Me"] = 0
end

optimal_happiness = seating_arrangements.map do |arrangement|
  arrangement.each_with_index.inject(0) do |s, (person, i)|
    i = -1 if i == arrangement.length - 1
    s + rules[person][arrangement[i - 1]] + rules[person][arrangement[i + 1]]
  end
end.max

puts optimal_happiness
