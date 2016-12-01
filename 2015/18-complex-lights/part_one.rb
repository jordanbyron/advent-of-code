require_relative '../advent'

GridGenerator = ->(size) {
  (1..size).map do |x|
    (1..size).map do |y|
      false
    end
  end
}

IterateGrid = ->(initial_grid, neighbor_evaluator = NeighborValues) {
  next_grid = GridGenerator[initial_grid.length]

  initial_grid.each_with_index do |row, x|
    row.each_with_index do |current_light, y|
      neighbor_values = neighbor_evaluator[initial_grid, x, y]
      lights_on       = neighbor_values.count {|v| v }

      next_grid[x][y] = if CornerOfGrid[initial_grid, x, y] # Part two stuff ...
                          true
                        elsif current_light && (lights_on == 2 || lights_on == 3)
                          true
                        elsif current_light
                          false
                        elsif !current_light && lights_on == 3
                          true
                        else
                          false
                        end
    end
  end

  next_grid
}

NeighborValues = ->(grid, x, y) {
  neighbors = [
    [x - 1, y - 1], [x - 1, y], [x - 1, y + 1], # Row Above
    [x, y - 1], [x, y + 1],                     # Same Row
    [x + 1, y - 1], [x + 1, y], [x + 1, y + 1]  # Row Below
  ]

  neighbors.map do |x, y|
    # neighbors that don't exist off the edge of the grid are "off"
    next false if x < 0 || y < 0 || x >= grid.length || y >= grid.length

    grid[x][y]
  end
}

PartTwoNeighborValues = ->(grid, x, y) {
  neighbors = [
    [x - 1, y - 1], [x - 1, y], [x - 1, y + 1], # Row Above
    [x, y - 1], [x, y + 1],                     # Same Row
    [x + 1, y - 1], [x + 1, y], [x + 1, y + 1]  # Row Below
  ]

  neighbors.map do |x, y|
    # neighbors that don't exist off the edge of the grid are "off"
    next false if x < 0 || y < 0 || x >= grid.length || y >= grid.length

    if CornerOfGrid[grid, x, y]
      true # These lights are broken and always on
    else
      grid[x][y]
    end
  end
}

CornerOfGrid = -> (grid, x, y) {
  (x == 0 && y == 0) ||
  (x == 0 && y == grid.length - 1) ||
  (y == 0 && x == grid.length - 1) ||
  (y == grid.length - 1 && x == grid.length - 1)
}


GridParser = ->(grid_data) {
  grid_data.split("\n").map do |row|
    row.chars.map do |light|
      light == '#'
    end
  end
}

GridPresenter = ->(grid) {
  grid.each do |row|
    puts row.map { |value| value ? '#' : '.' }.join
  end
}

describe 'GridParser' do
  it 'parses grids' do
    grid_data = '.#.#.#
...##.
#....#
..#...
#.#..#
####..'

    GridParser[grid_data].must_equal [
      [false, true, false, true, false, true],
      [false, false, false, true, true, false],
      [true, false, false, false, false, true],
      [false, false, true, false, false, false],
      [true, false, true, false, false, true],
      [true, true, true, true, false, false]
    ]
  end
end

describe 'IterateGrid' do
  let(:initial_grid) {
    [
      [false, true, false, true, false, true],
      [false, false, false, true, true, false],
      [true, false, false, false, false, true],
      [false, false, true, false, false, false],
      [true, false, true, false, false, true],
      [true, true, true, true, false, false]
    ]
  }

  it 'iterates' do
    step_one = IterateGrid[initial_grid]

    step_one.must_equal GridParser['..##..
..##.#
...##.
......
#.....
#.##..']

    step_two = IterateGrid[step_one]

    step_two.must_equal GridParser['..###.
......
..###.
......
.#....
.#....']

    step_three = IterateGrid[step_two]

    step_three.must_equal GridParser['...#..
......
...#..
..##..
......
......']
  end
end

describe 'NeighborValues' do
  let(:neighbor_grid) { [
      [false, true, false, true, false, true],
      [false, false, false, true, true, false],
      [true, false, false, false, false, true],
      [false, false, true, false, false, false],
      [true, false, true, false, false, true],
      [true, true, true, true, false, false]
    ]}

  it 'reports edges correctly' do
    NeighborValues[neighbor_grid, 0, 0].count {|v| v }.must_equal 1
    NeighborValues[neighbor_grid, 0, 0].count {|v| !v }.must_equal 7
  end

  it 'reports inner lights correctly' do
    NeighborValues[neighbor_grid, 2, 3].count {|v| v }.must_equal 3
    NeighborValues[neighbor_grid, 2, 3].count {|v| !v }.must_equal 5
  end
end

grid = GridParser[@input]

system("clear")
GridPresenter[grid]

100.times do
  grid = IterateGrid[grid, PartTwoNeighborValues]
  system("clear")
  GridPresenter[grid]
end

puts grid.inject(0) {|s, row| s + row.count {|v| v }}
