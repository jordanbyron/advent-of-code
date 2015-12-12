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
      else
        raise "Unknown action: '#{action}'"
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

  def brightness
    grid.flatten.inject(0) {|s, l| s + l.brightness }
  end

  private

  attr_reader :grid
end

class Light
  def initialize(x,y)
    @x          = x
    @y          = y
    @pos        = [x,y]
    @brightness = 0
  end

  def on
    @brightness += 1
  end

  def off
    @brightness += -1
    @brightness = 0 if @brightness < 0
  end

  def toggle
    @brightness += 2
  end

  attr_reader :brightness, :x, :y, :pos
end

describe LightGrid do
  let(:light_grid) { LightGrid.new }

  it 'can turn on all the lights' do
    command = 'toggle 0,0 through 999,999'

    light_grid.parse_command(command)

    light_grid.brightness.must_equal 2000000
  end

  it 'can toggle a row of lights' do
    command = 'turn on 0,0 through 0,0'

    light_grid.parse_command(command)

    light_grid.brightness.must_equal 1
  end

  it 'can turn off lights' do
    command = 'turn off 499,499 through 500,500'

    light_grid.parse_command(command)

    light_grid.brightness.must_equal 0
  end

  it 'can turn off then toggle on lights' do
    commands = [
      'turn off 0,0 through 0,0',
      'toggle 0,0 through 0,0'
    ]

    commands.each do |command|
      light_grid.parse_command(command)
    end

    light_grid.brightness.must_equal 2
  end
end

input = @input.split("\n")

lg = LightGrid.new

input.each do |command|
  lg.parse_command(command)
end

puts lg.brightness
