require_relative '../advent'

Visitor = ->(places, h = {}) {
  if places.one?
    return places.first
  else
    places.each do |place|
      h[place] = Visitor[places - [place]]
    end

    h
  end
}

module DistanceCalcualtor
  extend self

  def distance_for(origin, destination)
    distances[origin][destination] || distances[destination][origin]
  end

  def distances
    @distances ||= begin
      distances = {}

      File.read('input.txt').split("\n").each do |string|
        regex = /(?<start>\S+) to (?<finish>\S+) = (?<distance>\d+)/
        if data = regex.match(string)
          distances[data[:start]] ||= {}
          distances[data[:start]][data[:finish]] = data[:distance].to_i
        else
          raise "Error parsing '#{string}'"
        end
      end

      distances["Straylight"] = {}

      distances
    end
  end
end

class Leg
  def initialize(origin, destination)
    @origin      = origin
    @destination = destination
  end

  def distance
    DistanceCalcualtor.distance_for(origin, destination)
  end

  attr_reader :origin, :destination
end

class Route
  def self.all
    @all ||= []
  end

  def self.add(origin)
    route = new(origin)
    all << route
    route
  end

  def self.shortest
    shortest_distance = all.map(&:distance).min

    all.find {|route| route.distance == shortest_distance }
  end

  def self.longest
    longest_distance = all.map(&:distance).max

    all.find {|route| route.distance == longest_distance }
  end

  def initialize(origin)
    @legs         = []
    @current_stop = origin
  end

  attr_reader :legs

  def add_stop(destination)
    legs << Leg.new(current_stop, destination)
    @current_stop = destination
    legs.last
  end

  def distance
    legs.inject(0) {|sum, leg| sum + leg.distance }
  end

  def to_s
    if legs.any?
      legs.map {|l| l.origin }.join(' -> ') + " -> #{legs.last.destination}"
    else
      "Trip to no where from #{current_stop}"
    end
  end

  def inspect
    "#<Route> #{to_s}"
  end

  private

  attr_reader :current_stop
end

routes = Visitor[DistanceCalcualtor.distances.keys]

RoutesToArray = -> (hash, ancestors = [], results = []) {
  hash.each do |key, value|
    if value.is_a?(Hash)
      RoutesToArray[value, ancestors + [key], results]
    else
      results << (ancestors + [key, value])
    end
  end

  results
}

route_array = RoutesToArray[routes]

route_array.each do |trip|
  route = Route.add(trip.first)
  trip[1..-1].each do |destination|
    route.add_stop(destination)
  end
end

binding.pry
