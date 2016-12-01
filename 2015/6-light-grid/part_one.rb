require_relative '../advent'

class LightGrid
  def initialize
    @grid = (0..999).map do |x|
      (0..999).map do |y|
        Light.new(x, y)
      end
    end
  end

  def parse_command(command)
    regex = /(?<action>turn on|toggle|turn off) (?<start_x>\d+),(?<start_y>\d+) through (?<end_x>\d+),(?<end_y>\d+)/

    if data = regex.match(command)
      action = case data[:action]
      when 'turn on'
        :on
      when 'turn off'
        :off
      when 'toggle'
        :toggle
      end

      (data[:start_x].to_i..data[:end_x].to_i).each do |x|
        (data[:start_y].to_i..data[:end_y].to_i).each do |y|
          grid[x][y].send(action)
        end
      end
    else
      raise "Unknown command: '#{command}'"
    end
  end

  def lights_on
    grid.flatten.select {|l| l.on? }
  end

  private

  attr_reader :grid
end

class Light
  def initialize(x,y)
    @x     = x
    @y     = y
    @pos   = [x,y]
    @state = :off
  end

  def on
    @state = :on
  end

  def off
    @state = :off
  end

  def toggle
    on? ? off : on
  end

  def on?
    state == :on
  end

  def off?
    !on?
  end

  attr_reader :state, :x, :y, :pos
end

# describe LightGrid do
#   let(:light_grid) { LightGrid.new }

#   it 'can turn on all the lights' do
#     command = 'turn on 0,0 through 999,999'

#     light_grid.parse_command(command)

#     light_grid.lights_on.count.must_equal 1000000
#   end

#   it 'can toggle a row of lights' do
#     command = 'toggle 0,0 through 999,0'

#     light_grid.parse_command(command)

#     light_grid.lights_on.count.must_equal 1000
#   end

#   it 'can turn off lights' do
#     command_one = 'turn on 0,0 through 999,999'
#     command = 'turn off 499,499 through 500,500'

#     light_grid.parse_command(command_one)
#     light_grid.parse_command(command)

#     light_grid.lights_on.count.must_equal 1000000 - 4
#   end
# end

input = @input.split("\n")

lg = LightGrid.new

input.each do |command|
  lg.parse_command(command)
end

puts lg.lights_on.count
