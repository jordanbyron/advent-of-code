require_relative '../../advent'

input = @load_input[__FILE__]

ParseInstructionString = -> (instructions) {
  instructions.split(',').map do |instruction|
    instruction = instruction.strip

    {
      turn: instruction.chars[0],
      distance: instruction[1..-1].to_i
    }
  end
}

class Taxi
  DIRECTIONS = [:north, :west, :south, :east]

  def initialize
    @position = [0,0]
    @facing   = :north
  end

  attr_reader :position, :facing

  def turn(direction)
    direction = case direction
    when 'R'
      1
    when 'L'
      -1
    end

    @facing = DIRECTIONS[direction + DIRECTIONS.index(facing)]
    @facing = :north if facing.nil?

    facing
  end

  def step
    case facing
    when :north
      @position = [position[0], position[1] + 1]
    when :south
      @position = [position[0], position[1] - 1]
    when :west
      @position = [position[0] - 1, position[1]]
    when :east
      @position = [position[0] + 1, position[1]]
    end
  end

  def distance
    position.inject(0) {|s, v| s += v.abs }
  end
end

describe ParseInstructionString do
  it 'splits into turn and distance' do
    instructions = ParseInstructionString[input]

    instructions.each do |instruction|
      instruction[:turn].must_match /[RL]/
      instruction[:distance].to_s.must_match /\d+/
    end
  end
end

describe 'Taxi' do
  let(:taxi) { Taxi.new }

  it 'works with example one' do
    instructions = ParseInstructionString['R2, L3']

    instructions.each do |instruction|
      taxi.turn(instruction[:turn])
      instruction[:distance].times { taxi.step }
    end

    taxi.distance.must_equal 5
  end

  it 'works with example two' do
    instructions = ParseInstructionString['R2, R2, R2']

    instructions.each do |instruction|
      taxi.turn(instruction[:turn])
      instruction[:distance].times { taxi.step }
    end

    taxi.distance.must_equal 2
  end

  it 'works with example three' do
    instructions = ParseInstructionString['R5, L5, R5, R3']

    instructions.each do |instruction|
      taxi.turn(instruction[:turn])
      instruction[:distance].times { taxi.step }
    end

    taxi.distance.must_equal 12
  end
end

taxi              = Taxi.new
instructions      = ParseInstructionString[input]
part_two_distance = nil
visited_locations = Set.new

instructions.each do |instruction|
  taxi.turn(instruction[:turn])

  instruction[:distance].times do
    if visited_locations.include?(taxi.position) && part_two_distance.nil?
      part_two_distance = taxi.distance
    else
      visited_locations << taxi.position
    end

    taxi.step
  end
end

puts "Part one: #{taxi.distance}"
puts "Part two: #{part_two_distance}"
