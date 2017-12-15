require_relative '../../advent'

input = @load_input[__FILE__]
example_plan = 'The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.
The second floor contains a hydrogen generator.
The third floor contains a lithium generator.
The fourth floor contains nothing relevant.'

class Building
  def initialize(floors = [])
    @floors   = floors
    @elevator = Elevator.new
  end

  attr_reader :floors

  def safe?
    floors.all? {|floor| floor.safe? }
  end

  def ready_for_assembly?
    floors[0..2].all? {|floor| floor.contents.empty? } &&
    floors[3].microchips.any? &&
    floors[3].generators.length == floors[3].microchips.length
  end
end

class Floor
  def initialize(number)
    @number   = number
    @contents = []
  end

  attr_reader   :number
  attr_accessor :contents

  def safe?
    generators.empty? ||
    microchips.all? {|microchip| microchip.connected_to_power?(generators) }
  end

  def generators
    contents.select {|content| Generator === content } +
    (elevator && elevator.generators || [])
  end

  def microchips
    contents.select {|content| Microchip === content } +
    (elevator && elevator.microchips || [])
  end

  def elevator
    contents.find {|content| Elevator === content }
  end

  def to_s
    floor_number = "F#{number}"
    has_elevator = elevator ? "E " : "  "
    [floor_number, has_elevator, *microchips.map(&:to_s),
     *generators.map(&:to_s)].join(' ')
  end
end

class Elevator
  def initialize
    @contents = []
  end

  attr_reader :contents

  def can_move?
    @contents.any?
  end

  def at_capacity?
    @contents.count == 2
  end

  def generators
    contents.select {|content| Generator === content }
  end

  def microchips
    contents.select {|content| Microchip === content }
  end
end

class Generator
  def initialize(type)
    @type = type
  end

  attr_reader :type

  def to_s
    "#{type[0].upcase}G"
  end
end

class Microchip
  def initialize(type)
    @type = type
  end

  attr_reader :type

  def connected_to_power?(generators_on_floor)
    generators_on_floor.any? {|g| g.type == type }
  end

  def to_s
    "#{type[0].upcase}M"
  end
end

BuildingGenerator = ->(plans) {
  building = Building.new

  plans.split("\n").each do |floor_plan|
    number = /The (\w+) floor/.match(floor_plan).captures.first
    number = [nil, 'first', 'second', 'third', 'fourth'].index(number)

    floor = Floor.new(number)

    microchips = floor_plan.scan(/(\w+)-compatible microchip/).flatten
    generators = floor_plan.scan(/(\w+) generator/).flatten

    microchips.each do |type|
      floor.contents << Microchip.new(type)
    end

    generators.each do |type|
      floor.contents << Generator.new(type)
    end

    if number == 1
      floor.contents << Elevator.new
    end

    building.floors << floor
  end

  building
}

describe Building do
  let(:floors) { 4.times.map {|n| Floor.new(n) } }
  let(:building) { Building.new(floors) }

  it 'has floors' do
    building.floors.must_equal floors
  end

  it 'is safe when there is nothing in the building' do
    building.safe?.must_equal true
  end

  it 'is ready for assembly when all generators and microchips reach floor 4' do
    third_floor  = building.floors[2]
    fourth_floor = building.floors[3]

    building.ready_for_assembly?.must_equal false

    microchip = Microchip.new('hydrogen')
    fourth_floor.contents << microchip

    building.ready_for_assembly?.must_equal false

    # Wrong floor!
    generator = Generator.new('hydrogen')
    third_floor.contents << generator

    building.ready_for_assembly?.must_equal false

    # But it's still on the 3rd floor!
    fourth_floor.contents << generator

    building.ready_for_assembly?.must_equal false

    third_floor.contents.clear

    building.ready_for_assembly?.must_equal true
  end
end

describe Floor do
  let(:floor) { Floor.new(1) }

  it 'is safe when empty' do
    floor.safe?.must_equal true
  end

  it 'is safe when it only has microchips' do
    microchip = Microchip.new('hydrogen')

    floor.contents << microchip

    floor.safe?.must_equal true
  end

  it 'is safe when it has a microchip that is powered' do
    microchip = Microchip.new('hydrogen')
    generator = Generator.new('hydrogen')

    floor.contents << microchip
    floor.contents << generator

    floor.safe?.must_equal true
  end

  it 'is safe with just generators' do
    generator = Generator.new('hydrogen')

    floor.contents << generator

    floor.safe?.must_equal true
  end

  it 'is unsafe with a microchip that is not powered and another generator' do
    generator = Generator.new('hydrogen')
    microchip = Microchip.new('lithium')

    floor.contents << microchip
    floor.contents << generator

    floor.safe?.must_equal false
  end

  it 'considers elevator content when checking safety' do
    elevator  = Elevator.new
    generator = Generator.new('hydrogen')
    microchip = Microchip.new('lithium')

    elevator.contents << generator

    floor.contents << microchip
    floor.contents << elevator

    floor.safe?.must_equal false
  end
end

describe Elevator do
  let(:elevator) { Elevator.new }

  it 'can only have 2 items' do
    2.times { elevator.contents << Microchip.new('hydrogen') }

    elevator.at_capacity?.must_equal true
  end

  it 'can only move if it has passengers' do
    elevator.can_move?.must_equal false

    elevator.contents << Microchip.new('hydrogen')

    elevator.can_move?.must_equal true
  end
end

describe 'BuildingGenerator' do
  let(:building) { BuildingGenerator[example_plan] }

  it 'creates floors' do
    building.floors.length.must_equal 4
  end

  it 'puts the elevator on the first floor' do
    building.floors[0].elevator.wont_equal nil
  end

  it 'puts the two microchips on the first floor' do
    floor = building.floors[0]

    floor.microchips.length.must_equal 2
  end

  it 'puts a generator on the second floor' do
    floor = building.floors[1]

    floor.generators.length.must_equal 1
  end

  it 'puts a generator on the third floor' do
    floor = building.floors[2]

    floor.generators.length.must_equal 1
  end

  it 'leaves the fourth floor empty' do
    floor = building.floors[3]

    floor.contents.length.must_equal 0
  end

  it 'starts in a safe state' do
    building.safe?.must_equal true
  end
end

describe 'Mover' do
  let(:building) { BuildingGenerator[example_plan] }

  it 'moves things' do
    Mover[building]
  end
end

Mover = ->(building) {
  current_floor = building.floors.find {|f| f.elevator }
  next_floor    = building.floors[current_floor.number + 1]
  elevator      = current_floor.elevator
  objects       = current_floor.microchips + current_floor.generators

  arrangements = objects.combination(1).to_a + objects.combination(2).to_a

  valid_arrangements = arrangements.select do |cargo|
    elevator.contents += cargo

    current_floor.contents.delete(elevator)
    next_floor.contents << elevator

    building.safe?
  end
}
