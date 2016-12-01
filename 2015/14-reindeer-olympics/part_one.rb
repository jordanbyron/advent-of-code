require_relative '../advent'

class Reindeer
  def initialize(name, speed, fly_duration, rest_duration)
    @name              = name
    @speed             = speed.to_i
    @fly_duration      = fly_duration.to_i
    @rest_duration     = rest_duration.to_i
    @distance_traveled = 0
    @state             = :flying
    @step              = 0
    @points            = 0
  end

  def tick(steps_to_add = 1)
    @step += steps_to_add

    duration      = fly_duration + rest_duration
    whole_steps   = step / duration
    partial_steps = step % duration

    if partial_steps > fly_duration
      partial_steps = fly_duration
      @state = :resting
    else
      @state = :flying
    end

    @distance_traveled = (whole_steps * fly_duration * speed) +
                         (speed * partial_steps)
  end

  def flying?
    @state == :flying
  end

  def resting?
    !flying?
  end

  attr_reader :step, :fly_duration, :speed, :rest_duration, :distance_traveled
  attr_accessor :points
end

ReindeerParser = ->(input) {
  regex = /(?<name>\S+) can fly (?<speed>\d*) km\/s for (?<fly_duration>\d*) seconds, but then must rest for (?<rest_duration>\d*) seconds./

  input.split("\n").map do |row|
    if data = regex.match(row)
      Reindeer.new(data[:name], data[:speed], data[:fly_duration],
                   data[:rest_duration])
    else
      raise "Unable to parse '#{row}'"
    end
  end
}

reindeer = ReindeerParser[@input]

describe Reindeer do
  let(:comet)  { Reindeer.new("Comet", 14, 10, 127) }
  let(:dancer) { Reindeer.new("Dancer", 16, 11, 162) }

  it 'one second' do
    comet.tick
    dancer.tick

    comet.distance_traveled.must_equal 14
    dancer.distance_traveled.must_equal 16
  end

  it '10 seconds' do
    comet.tick(10)
    dancer.tick(10)

    comet.distance_traveled.must_equal 140
    dancer.distance_traveled.must_equal 160
  end

  it '11 seconds' do
    comet.tick(11)
    dancer.tick(11)

    comet.distance_traveled.must_equal 140
    comet.resting?.must_equal true
    dancer.distance_traveled.must_equal 176
  end

  it '12 seconds' do
    comet.tick(12)
    dancer.tick(12)

    comet.distance_traveled.must_equal 140
    comet.resting?.must_equal true
    dancer.distance_traveled.must_equal 176
    dancer.resting?.must_equal true
  end

  it '1000 seconds' do
    comet.tick(1_000)
    dancer.tick(1_000)

    comet.distance_traveled.must_equal 1120
    dancer.distance_traveled.must_equal 1056
  end
end

2503.times do
  reindeer.each(&:tick)

  lead_distance = reindeer.map(&:distance_traveled).max

  reindeer.select {|r| r.distance_traveled == lead_distance }.
    each {|r| r.points += 1 }
end

puts reindeer.map(&:points).max
