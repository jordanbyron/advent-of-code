require_relative '../advent'

class Sleigh
  def initialize
    @positions = {santa: [0,0], robo: [0,0]}
    @houses   = Hash.new

    @current_person = :santa # Santa goes first
    houses[positions[:santa]] = true # First house always gets a present
  end

  def move(direction)
    position = current_person_position

    case direction
    when '^'
      # Up (North)
      position = [position[x], position[y] + 1]
    when 'v'
      # Down (South)
      position = [position[x], position[y] - 1]
    when '<'
      # Left (West)
      position = [position[x] - 1, position[y]]
    when '>'
      # Right (East)
      position = [position[x] + 1, position[y]]
    end

    houses[position] = true
    positions[current_person] = position
    @current_person = current_person == :santa ? :robo : :santa
  end

  def houses_visited
    houses.keys.length
  end

  private

  attr_reader :houses, :positions, :current_person

  def x
    0
  end

  def y
    1
  end

  def current_person_position
    positions[current_person]
  end
end

describe Sleigh do
  let(:sleigh) { Sleigh.new }

  it 'moves' do
    '^v'.chars.each do |direction|
      sleigh.move(direction)
    end

    sleigh.houses_visited.must_equal 3
  end

  it 'in complicated formations' do
    '^>v<'.chars.each {|m| sleigh.move(m) }

    sleigh.houses_visited.must_equal 3
  end

  it 'back and fourth' do
    '^v^v^v^v^v'.chars.each {|m| sleigh.move(m) }

    sleigh.houses_visited.must_equal 11
  end
end

sleigh = Sleigh.new
moves  = @input.chars
moves.each {|m| sleigh.move(m) }

puts sleigh.houses_visited
