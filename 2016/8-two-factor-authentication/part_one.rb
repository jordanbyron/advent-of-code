require_relative '../../advent';

input = @load_input[__FILE__]

class Screen
  def initialize(width, height)
    @width  = width
    @height = height
    @grid   = height.times.map do
      width.times.map do
        "."
      end
    end
  end

  attr_reader :width, :height, :grid

  def toggle(x, y)
    value = at(x, y)

    set(x,y, value == '.' ? '#' : '.')
  end

  def on(x, y)
    set x, y, '#'
  end

  def at(x, y)
    grid[y][x]
  end

  def set(x, y, value)
    grid[y][x] = value
  end

  def turn_on_block(width, height)
    height.times do |y|
      width.times do |x|
        on(x,y)
      end
    end
  end

  def rotate_column(column, shift)
    column_values = grid.transpose[column].rotate(-shift)

    column_values.each_with_index do |value, x|
      set(column, x, value)
    end
  end

  def rotate_row(row, shift)
    row_values = grid[row].rotate(-shift)

    row_values.each_with_index do |value, y|
      set(y, row, value)
    end
  end

  def to_s
    grid.length.times.each do |y|
      grid[y].each do |cell|
        print cell
      end
      puts
    end

    "<Screen height=#{height} width=#{width}>"
  end
end

InstructionReader = ->(instructions, screen) {
  instructions.split("\n").each do |instruction|
    case instruction
    when /rect/
      data = /rect (\d+)x(\d+)/.match(instruction)
      screen.turn_on_block(data.captures[0].to_i, data.captures[1].to_i)
    when /rotate column/
      data = /rotate column x=(\d+) by (\d+)/.match(instruction)
      screen.rotate_column(data.captures[0].to_i, data.captures[1].to_i)
    when /rotate row/
      data = /rotate row y=(\d+) by (\d+)/.match(instruction)
      screen.rotate_row(data.captures[0].to_i, data.captures[1].to_i)
    end
  end

  screen
}

describe Screen do
  let(:width)  { 7 }
  let(:height) { 3 }
  let(:screen) { Screen.new(width, height) }

  it 'generates a grid based on the height, width' do
    screen.grid.length.must_equal height
    screen.grid.each do |row|
      row.length.must_equal width
    end
  end

  it 'can toggle pixel values' do
    screen.toggle(0,0)

    screen.at(0,0).must_equal '#'
  end

  it 'can turn on pixels in blocks' do
    screen.turn_on_block(2, 2)

    screen.at(0,0).must_equal '#'
    screen.at(0,1).must_equal '#'
    screen.at(1,0).must_equal '#'
    screen.at(1,1).must_equal '#'
  end

  it 'can rotate pixels by columns' do
    screen.turn_on_block(3,2)

    screen.rotate_column(1, 1)

    screen.at(1,0).must_equal '.'
    screen.at(1,1).must_equal '#'
    screen.at(1,2).must_equal '#'
  end

  it 'can rotate pixels by rows' do
    screen.turn_on_block(3,2)
    screen.rotate_column(1, 1)

    screen.rotate_row(0, 4)

    screen.grid[0].join.must_equal '....#.#'
  end

  it 'completes all examples' do
    screen.turn_on_block(3,2)
    screen.rotate_column(1, 1)
    screen.rotate_row(0, 4)
    screen.rotate_column(1, 1)

    screen.grid[0].join.must_equal '.#..#.#'
    screen.grid[1].join.must_equal '#.#....'
    screen.grid[2].join.must_equal '.#.....'
  end
end

describe 'InstructionReader' do
  let(:screen) { Screen.new(7, 3) }

  it 'works with the example instructions' do
    instructions = "rect 3x2\nrotate column x=1 by 1\nrotate row y=0 by 4\n" +
                   "rotate column x=1 by 1"

    InstructionReader[instructions, screen]

    screen.grid[0].join.must_equal '.#..#.#'
    screen.grid[1].join.must_equal '#.#....'
    screen.grid[2].join.must_equal '.#.....'
  end
end

screen = Screen.new(50, 6)

InstructionReader[input, screen]

part_one = screen.grid.inject(0) do |s, row|
  s += row.count {|v| v == '#' }
end

puts "Part One: #{part_one}"

puts "Part Two:"
50.times { print "-" }
puts ""
screen.to_s
50.times { print "-" }
