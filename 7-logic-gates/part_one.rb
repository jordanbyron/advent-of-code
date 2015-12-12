require_relative '../advent'

class Circuit
  def initialize(commands)
    @wires = {}
    run(commands)
  end

  attr_reader :wires

  def run(commands)
    commands.split("\n").each do |command|
      run_command(command)
    end
  end

  def run_command(command)
    assign = /\A(?<value>\S+) -> (?<wire>\D+)/
    operator = /(?<input_one>\S+) (?<operation>AND|OR|LSHIFT|RSHIFT) (?<input_two>\S+) -> (?<output>\D+)/
    complement = /NOT (?<input>\D+) -> (?<output>\D+)/

    if data = assign.match(command)
      # If the parse was wrong, then we have a wire value
      value = wire_or_value(data[:value])

      add_wire data[:wire], value
    elsif data = operator.match(command)
      input_one = wire_or_value(data[:input_one])
      input_two = wire_or_value(data[:input_two])

      case data[:operation]
      when 'AND'
        add_wire data[:output], -> {
          input_one.call & input_two.call
        }
      when 'OR'
        add_wire data[:output], -> {
          input_one.call | input_two.call
        }
      when 'LSHIFT'
        add_wire data[:output], -> {
          input_one.call << input_two.call
        }
      when 'RSHIFT'
        add_wire data[:output], -> {
          input_one.call >> input_two.call
        }
      else
        raise "Unknown operation '#{data[:operation]}'"
      end
    elsif data = complement.match(command)
      add_wire data[:output], -> { 65535 - wires[data[:input]].output }
    else
      raise "Unknown command '#{command}'"
    end
  end

  def wires_output
    wires.map {|k, v| [ k, v.output] }.to_h
  end

  private

  def add_wire(id, input)
    wire           = Wire.new(id)
    wire.input     = input
    wires[wire.id] = wire
  end

  def wire_or_value(v)
    -> { (v.to_i.to_s == v) ? v.to_i : wires[v].output }
  end
end

class Wire
  def initialize(id)
    @id = id
  end

  attr_accessor :input
  attr_reader :id

  def output
    @output ||= input.call
  end
end

describe Circuit do
  it 'works' do
    commands = "123 -> x
x AND y -> d
x OR y -> e
x LSHIFT 2 -> f
456 -> y
y RSHIFT 2 -> g
NOT x -> h
NOT y -> i
1 -> xx
x AND xx -> yy
yy -> z
1 AND x -> b"

    circuit = Circuit.new(commands)

    correct = {"x" => 123, "y" => 456, "d" => 72, "e" => 507,
               "f" => 492, "g" => 114, "h" => 65412, "i" => 65079,
               "xx" => 1, "yy" => 1, "z" => 1, "b" => 1}

    circuit.wires_output.each do |k, v|
      v.must_equal correct[k]
    end
  end
end

circuit = Circuit.new(@input)

puts circuit.wires['a']
