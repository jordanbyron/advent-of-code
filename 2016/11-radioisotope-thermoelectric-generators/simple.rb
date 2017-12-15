require_relative '../../advent'
require 'deep_clone'

input = @load_input[__FILE__]
example_plan = 'The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
The second floor contains a hydrogen generator.
The third floor contains a lithium generator.
The fourth floor contains nothing relevant.'

BuildingGenerator = ->(plans) {
  building = {}

  plans.split("\n").each do |floor_plan|
    number = /The (\w+) floor/.match(floor_plan).captures.first
    number = [nil, 'first', 'second', 'third', 'fourth'].index(number)

    floor = []

    microchips = floor_plan.scan(/(\w+)-compatible microchip/).flatten
    generators = floor_plan.scan(/(\w+) generator/).flatten

    microchips.each do |type|
      floor << "#{type}-M"
    end

    generators.each do |type|
      floor << "#{type}-G"
    end

    if number == 1
      floor << "elevator"
    end

    building[number] = floor.sort
  end

  building
}

FloorSafe = ->(floor) {
  microchips = floor.select {|obj| obj[/\-M/] }
  generators = floor.select {|obj| obj[/\-G/] }

  generators.empty? || microchips.all? do |chip|
    generators.any? {|g| g[/\w+/] == chip[/\w+/] }
  end
}

AllSafe = ->(building) {
  building.values.all? do |floor|
    FloorSafe[floor]
  end
}

ValidMoves = ->(floors) {
  moves = []

  current_floor_number, current_floor_contents = floors.
    find {|k,v| v.include? "elevator" }

  current_floor_contents = DeepClone.clone(current_floor_contents)
  current_floor_contents.delete("elevator")

  move_options = current_floor_contents.combination(2).to_a +
    current_floor_contents

  move_options.each do |objects_to_move|
    objects_to_move = [objects_to_move].flatten

    if current_floor_number == 1
      # Can only go up
      moves << MoveObjects[floors, objects_to_move, current_floor_number, :up]
    elsif current_floor_number == 4
      # Can only go down
      moves << MoveObjects[floors, objects_to_move, current_floor_number, :down]
    else
      # Can go up and down
      moves << MoveObjects[floors, objects_to_move, current_floor_number, :up]
      moves << MoveObjects[floors, objects_to_move, current_floor_number, :down]
    end
  end

  moves.select {|move| AllSafe[move] }
}

MoveObjects = ->(floors, objects, current_floor, direction) {
  move      = DeepClone.clone(floors)
  direction = direction == :up ? 1 : -1

  move[current_floor].delete("elevator")

  move[current_floor + direction] << "elevator"
  move[current_floor + direction] += objects
  move[current_floor + direction] = move[current_floor + direction].sort
  objects.each {|obj| move[current_floor].delete(obj) }

  move
}

ReadyForAssembly = ->(floors) {
  floors.values[0..2].all? {|floor| floor.empty? } &&
  floors[4].any? {|f| f[/-M/] } &&
  floors[4].count {|o| o[/-M/] } == floors[4].count {|o| o[/-G/] }
}

class MinimumMoves
  def initialize
    @global_history = {}
    @best_time      = 100
  end

  attr_reader :global_history, :best_time

  def call(floors)
    problem_solver(floors) do |moves|
      if moves < best_time
        puts "New Best Time: #{moves}"
        @best_time = moves
      end
    end

    best_time
  end

  def problem_solver(floors, history = 0, &block)
    history += 1
    moves    = ValidMoves[floors]

    return if global_history[[floors, moves]] == true

    global_history[[floors, moves]] = true

    moves.each do |move|
      if ReadyForAssembly[move]
        block.call(history)
      elsif history < best_time
        problem_solver(move, history, &block)
      else
        "Too many moves!"
      end
    end
  end
end

describe 'BuildingGenerator' do
  let(:building) { BuildingGenerator[example_plan] }

  it 'creates 4 floors' do
    building.length.must_equal 4
  end

  it 'sets the elevator on the first floor' do
    building[1].must_include 'elevator'
  end

  it 'puts the two microchips on the first floor' do
    building[1].must_include 'hydrogen-M'
    building[1].must_include 'lithium-M'
  end

  it 'puts a generator on the second floor' do
    building[2].must_include 'hydrogen-G'
  end

  it 'puts a generator on the third floor' do
    building[3].must_include 'lithium-G'
  end

  it 'leaves the fourth floor empty' do
    building[4].empty?.must_equal true
  end
end

describe 'FloorSafe' do
  it 'is safe when empty' do
    FloorSafe[[]].must_equal true
  end

  it 'is safe when there are no generators' do
    FloorSafe[['hydrogen-M']].must_equal true
  end

  it 'is safe with powered microchips' do
    FloorSafe[['hydrogen-M', 'hydrogen-G']].must_equal true
  end

  it 'is unsafe with a microchip that is not powered and another generator' do
    FloorSafe[['hydrogen-M', 'lithium-G']].must_equal false
  end

  it 'can be used to verify a whole building of floors' do
    building = BuildingGenerator[example_plan]

    building.values.all? do |floor|
      FloorSafe[floor]
    end.must_equal true
  end
end

describe 'ValidMoves' do
  let(:starting_building) { BuildingGenerator[example_plan] }

  it 'shows only one move for the first example' do
    moves = ValidMoves[starting_building]

    moves.length.must_equal 1

    AllSafe[moves.first].must_equal true
  end

  it 'moves items again' do
    next_building = ValidMoves[starting_building].first

    moves = ValidMoves[next_building]

    moves.count.must_equal 3
  end

  it 'comes up with the move I want it to' do
    floors = {
      1 => ["lithium-M"],
      2 => [],
      3 => ["elevator", "hydrogen-G", "hydrogen-M", "lithium-G"],
      4 => []
    }

    moves = ValidMoves[floors]

    moves.must_include({
      1 => ["lithium-M"], 2 => ["elevator", "hydrogen-M"],
      3 => ["hydrogen-G", "lithium-G"], 4 => []})
  end

  it 'keeps going' do
    floors = {
      1 => ["lithium-M"],
      2 => ["elevator", "hydrogen-M"],
      3 => ["hydrogen-G", "lithium-G"],
      4 => []
    }

    moves = ValidMoves[floors]

    moves.must_include({1=>["elevator", "hydrogen-M", "lithium-M"], 2=>[], 3=>["hydrogen-G", "lithium-G"], 4=>[]})
  end

  it 'and going' do
    floors = {
      1 => ["elevator", "hydrogen-M", "lithium-M"],
      2 => [],
      3 => ["hydrogen-G", "lithium-G"],
      4 => []
    }

    moves = ValidMoves[floors]

    moves.must_include({
      1 => [],
      2 => ["elevator", "hydrogen-M", "lithium-M"],
      3 => ["hydrogen-G", "lithium-G"],
      4 => []
    })
  end

  it 'almost there' do
    floors = {
      1 => [],
      2 => ["elevator", "hydrogen-M", "lithium-M"],
      3 => ["hydrogen-G", "lithium-G"],
      4 => []
    }

    moves = ValidMoves[floors]

    moves.must_include({
      1 => [],
      2 => [],
      3 => ["elevator", "hydrogen-G", "hydrogen-M", "lithium-G", "lithium-M"],
      4 => []
    })
  end
end

describe 'MinimumMoves' do
  it 'Solves problems?' do
    floors = BuildingGenerator[example_plan]

    min_moves = MinimumMoves.new

    min_moves.call(floors)
    min_moves.best_time.must_equal 11
  end
end

describe 'ReadyForAssembly' do
  let(:building) { BuildingGenerator[example_plan] }

  it 'returns false for buildings that are not ready' do
    ReadyForAssembly[building].must_equal false
  end

  it 'returns true for buildings that are ready' do
    building[1].clear
    building[2].clear
    building[3].clear

    building[4] << "hydrogen-M"
    building[4] << "hydrogen-G"

    ReadyForAssembly[building].must_equal true
  end
end

# building = BuildingGenerator[input]
# min_moves = MinimumMoves.new

# min_moves.call(building)

# puts "Part One: #{min_moves.best_time}"
