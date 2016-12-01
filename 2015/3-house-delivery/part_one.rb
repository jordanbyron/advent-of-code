require_relative '../advent'

class Sleigh
  def initialize
    @position = [0,0]
    @houses   = Hash.new

    houses[position] = true # First house always gets a present
  end

  def move(direction)
    case direction
    when '^'
      # Up (North)
      @position = [position[x], position[y] + 1]
    when 'v'
      # Down (South)
      @position = [position[x], position[y] - 1]
    when '<'
      # Left (West)
      @position = [position[x] - 1, position[y]]
    when '>'
      # Right (East)
      @position = [position[x] + 1, position[y]]
    end

    houses[position] = true
  end

  def houses_visited
    houses.keys.length
  end

  private

  attr_reader :houses, :position

  def x
    0
  end

  def y
    1
  end
end

describe Sleigh do
  let(:sleigh) { Sleigh.new }

  it 'moves' do
    %w[>].each do |direction|
      sleigh.move(direction)
    end

    sleigh.houses_visited.must_equal 2
  end

  it 'in complicated formations' do
    '^>v<'.chars.each {|m| sleigh.move(m) }

    sleigh.houses_visited.must_equal 4
  end

  it 'back and fourth' do
    '^v^v^v^v^v'.chars.each {|m| sleigh.move(m) }

    sleigh.houses_visited.must_equal 2
  end
end

sleigh = Sleigh.new
moves  = @input.chars
moves.each {|m| sleigh.move(m) }

puts sleigh.houses_visited
