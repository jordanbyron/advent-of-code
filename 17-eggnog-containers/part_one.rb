require_relative '../advent'

IDGenerator = -> {
  ids = ('a'..'z').to_a
  -> {
    ids.shift
  }
}

FillerUp = ->(quantity, containers) {
  generator = IDGenerator.call
  container_ids = containers.map {|value| [generator.call, value] }.to_h
  combinations = []

  (1..containers.length).each do |q|
    container_ids.keys.combination(q) do |container_set|
      values = container_set.map {|k| container_ids[k] }
      if values.inject(0) {|s, c| s + c } == quantity
        combinations << container_set
      end
    end
  end

  combinations.each {|a| a.sort! }.uniq
}

describe 'FillerUp' do
  let(:containers) { [20, 15, 10, 5, 5] }
  let(:eggnog) { 25 }

  it 'calculates the number of combinations to fill containers' do
    FillerUp[eggnog, containers].must_equal 4
  end
end

result   = FillerUp[150, @input.split("\n").map(&:to_i)]

part_one = result.length

puts part_one

smallest = result.map   {|r| r.length}.min
part_two = result.count {|r| r.length == smallest }

puts part_two
