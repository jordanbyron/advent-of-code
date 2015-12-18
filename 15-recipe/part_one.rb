require_relative '../advent'

class Ingredient
  def initialize(name, properties = {})
    @name       = name
    @capacity   = properties[:capacity].to_i
    @durability = properties[:durability].to_i
    @flavor     = properties[:flavor].to_i
    @texture    = properties[:texture].to_i
    @calories   = properties[:calories].to_i
  end

  attr_reader :name, :capacity, :durability, :flavor, :texture, :calories
end

IngredientParser = ->(input) {
  regex = /(?<name>\S+): capacity (?<capacity>[-]?\d+), durability (?<durability>[-]?\d+), flavor (?<flavor>[-]?\d+), texture (?<texture>[-]?\d+), calories (?<calories>[-]?\d+)/

  input.map do |row|
    if data = regex.match(row)
      Ingredient.new(data[:name], data)
    else
      raise "Unable to parse '#{row}'"
    end
  end
}

RecipeScorer = ->(ingredient_ratios) {
  sum = ingredient_ratios.inject(Hash.new(0)) do |sum, (q, i)|
    sum[:capacity]   += q * i.capacity
    sum[:durability] += q * i.durability
    sum[:flavor]     += q * i.flavor
    sum[:texture]    += q * i.texture

    sum
  end

  sum.each do |property, v|
    if v < 0
      sum[property] = 0
    end
  end

  sum.values.inject(&:*)
}

CalorieScorer = ->(ingredient_ratios) {
  ingredient_ratios.inject(0) do |sum, (q, i)|
    sum + q * i.calories
  end
}

describe 'RecipeScorer' do
  let(:ingredients) { IngredientParser[[
    'Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8',
    'Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3']] }

  it 'scores recipes' do
    RecipeScorer[{44 => ingredients.first, 56 => ingredients.last}].must_equal 62842880
  end
end

ingredients = IngredientParser[@input.split("\n")]
part_one_result = 0
part_two_result = 0

(0..100).to_a.permutation(4).each do |ratio|
  next unless ratio.inject(0) {|s, i| s + i } == 100

  h = {}

  ratio.each_with_index do |amount, i|
    h[amount] = ingredients[i]
  end

  score = RecipeScorer[h]

  if score > part_one_result
    part_one_result = score
  end

  if CalorieScorer[h] == 500 && score > part_two_result
    part_two_result = score
  end
end

puts part_one_result
puts "---"
puts part_two_result
