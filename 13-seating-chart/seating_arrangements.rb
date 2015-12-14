require_relative '../advent'
require 'csv'

people = @input.split("\n").map {|r| r.split(' ').first }.uniq
people << "Me"

SeatingArrangementGenerator = ->(people, h = {}) {
  if people.one?
    return people.first
  else
    people.map do |person|
      h[person] = SeatingArrangementGenerator[people - [person]]
    end

    h
  end
}

# Return of the Hash to Array proc from #9
#
RoutesToArray = -> (hash, ancestors = [], results = []) {
  hash.each do |key, value|
    if value.is_a?(Hash)
      RoutesToArray[value, ancestors + [key], results]
    else
      results << (ancestors + [key, value])
    end
  end

  results
}

seating_hash = SeatingArrangementGenerator[people]

seating_hash.delete_if {|k,_| k != people.first }

seating_arrangements = RoutesToArray[seating_hash]

CSV.open('part_two_arrangements.csv', 'wb') do |csv|
  seating_arrangements.each do |r|
    csv << r
  end
end
