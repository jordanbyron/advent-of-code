require_relative '../../advent'

input = @load_input[__FILE__]

class Factory
  def initialize
    @bots    = Hash.new {|h,k| h[k] = Receptacle.new(k) }
    @outputs = Hash.new {|h,k| h[k] = Receptacle.new(k) }
  end

  attr_reader :bots, :outputs
end

class Receptacle
  def initialize(id)
    @id     = id
    @values = []
  end

  attr_accessor :values
  attr_reader   :id

  def high
    values.max
  end

  def low
    values.min
  end
end

VALUE_REGEX = /value (?<value>\d+) goes to (?<receptacle>bot|output) (?<id>\d+)/
GIVE_REGEX  = /bot (?<source_bot_id>\d+) gives low to (?<low_type>bot|output) (?<low_id>\d+) and high to (?<high_type>bot|output) (?<high_id>\d+)/

InstructionParser = ->(instructions, factory, &block) {
  instructions = instructions.split("\n")

  value_instructions = instructions.select {|i| i[/\Avalue/] }

  value_instructions.each do |instruction|
    data = VALUE_REGEX.match(instruction)

    case data[:receptacle]
    when 'bot'
      factory.bots[data[:id].to_i].values << data[:value].to_i
    when 'output'
      factory.outputs[data[:id].to_i].values << data[:value].to_i
    end

    instructions.delete(instruction)
  end

  until(instructions.empty?) do
    instruction = instructions.shift

    data = GIVE_REGEX.match(instruction)

    source_bot = factory.bots[data[:source_bot_id].to_i]

    if source_bot.values.count == 2
      # Do the transaction
      low_receptacle = factory.
        public_send("#{data[:low_type]}s")[data[:low_id].to_i]
      high_receptacle = factory.
        public_send("#{data[:high_type]}s")[data[:high_id].to_i]

      block.call(source_bot, low_receptacle, high_receptacle) if block

      low_receptacle.values  << source_bot.low
      high_receptacle.values << source_bot.high

      source_bot.values.clear
    else
      instructions << instruction
    end
  end

  factory
}

describe 'InstructionParser' do
  let(:instructions) {
    %{value 5 goes to bot 2
bot 2 gives low to bot 1 and high to bot 0
value 3 goes to bot 1
bot 1 gives low to output 1 and high to bot 0
bot 0 gives low to output 2 and high to output 0
value 2 goes to bot 2}
  }
  let(:factory) { Factory.new }

  it 'loads value statements first' do
    InstructionParser[instructions, factory]

    factory.outputs[0].values.must_include 5
    factory.outputs[1].values.must_include 2
    factory.outputs[2].values.must_include 3
  end

  it 'can check which bot compares 5 and 2 values' do
    bot = nil
    InstructionParser.call(instructions, factory) do |source, low, high|
      if source.values.include?(5) && source.values.include?(2)
        bot = source
      end
    end

    bot.id.must_equal 2
  end
end

factory = Factory.new
bot     = nil

InstructionParser.call(input, factory) do |source|
  if source.values.include?(61) && source.values.include?(17)
    bot = source
  end
end

part_two = factory.outputs[0].values.first * factory.outputs[1].values.first *
          factory.outputs[2].values.first

puts "Part One: #{bot.id}"
puts "Part Two: #{part_two}"
