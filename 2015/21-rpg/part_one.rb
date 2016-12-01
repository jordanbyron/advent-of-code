require_relative '../advent'

class Item
  def initialize(name, type, cost, damage, armor)
    @name   = name
    @type   = type
    @cost   = cost
    @damage = damage
    @armor  = armor
  end

  attr_reader :name, :type, :cost, :damage, :armor
end

# Players and Bosses are characters
#
class Character
  def initialize(name, hit_points, damage, armor)
    @name       = name
    @hit_points = hit_points
    @damage     = damage
    @armor      = armor
  end

  def attack(victim, verbose = false)
    hit_damage             = [damage - victim.armor, 1].max
    victim_original_health = victim.hit_points

    victim.take_damage(hit_damage)

    if verbose
      puts "#{name} \u2694  #{victim.name}"
      puts "  #{victim_original_health}  \u2665  #{victim.hit_points}"
    end
  end

  def take_damage(hit_damage)
    @hit_points -= hit_damage
  end

  def dead?
    hit_points <= 0
  end

  attr_reader :name, :hit_points, :damage, :armor
end

store = [
  Item.new('Dagger',     :weapon,  8, 4, 0),
  Item.new('Shortsword', :weapon, 10, 5, 0),
  Item.new('Warhammer',  :weapon, 25, 6, 0),
  Item.new('Longsword',  :weapon, 40, 7, 0),
  Item.new('Greataxe',   :weapon, 74, 8, 0),

  Item.new('Leather',    :armor,  13, 0, 1),
  Item.new('Chainmail',  :armor,  31, 0, 2),
  Item.new('Splintmail', :armor,  53, 0, 3),
  Item.new('Bandedmail', :armor,  75, 0, 4),
  Item.new('Platemail',  :armor, 102, 0, 5),

  Item.new('Damage +1',  :ring,  25, 1, 0),
  Item.new('Damage +2',  :ring,  50, 2, 0),
  Item.new('Damage +3',  :ring, 100, 3, 0),
  Item.new('Defense +1', :ring,  20, 0, 1),
  Item.new('Defense +2', :ring,  40, 0, 2),
  Item.new('Defense +3', :ring,  80, 0, 3)
]

weapons = store.select {|i| i.type == :weapon }
armor   = store.select {|i| i.type == :armor }
rings   = store.select {|i| i.type == :ring }

FightToTheDeath = ->(player_one, player_two, verbose = false) {
  winner = nil

  [player_one, player_two].cycle do |attacker|
    victim = [player_one, player_two].find {|p| p != attacker }

    attacker.attack(victim, verbose)

    if victim.dead?
      winner = attacker
      puts "\u2620  #{victim.name}" if verbose
      break
    end
  end

  winner
}

# Max One Weapon, One Armor, 2 Rings.
#
LimitYeCarry = ->(items) {
  purchased_weapons = items.select {|i| i.type == :weapon }
  purchased_armor   = items.select {|i| i.type == :armor }
  purchased_rings   = items.select {|i| i.type == :ring }

  # Allow no weapons / armor / rings
  #
  purchased_weapons << nil
  purchased_armor   << nil
  purchased_rings   += [nil, nil]

  carry_combos = []

  purchased_weapons.each do |weapon|
    purchased_armor.each do |armor|
      purchased_rings.combination(2).each do |rings|
        carry_combos << ([weapon, armor] + rings.flatten).compact
      end
    end
  end

  carry_combos
}

describe 'Combat' do
  let(:player) { Character.new("Player", 8, 5, 5) }
  let(:boss)   { Character.new("Boss", 12, 7, 2) }

  it 'lets the player go first and win' do
    FightToTheDeath[player, boss].must_equal player

    player.hit_points.must_equal 2
  end
end

cheapest_items = store
most_expensive = []

LimitYeCarry[store].each do |carry|
  player = Character.new("Player", 100,
             carry.inject(0) {|s, i| s + i.damage },
             carry.inject(0) {|s, i| s + i.armor })

  # Reset boss from the last fight
  boss   = Character.new("Boss", 103, 9, 2)
  winner = FightToTheDeath[player, boss]

  if boss.dead?
    if carry.inject(0) {|s, i| s + i.cost } <
      cheapest_items.inject(0) {|s, i| s + i.cost }
      cheapest_items = carry
    end
  else
    if carry.inject(0) {|s, i| s + i.cost } >
      most_expensive.inject(0) {|s, i| s + i.cost }
      most_expensive = carry
    end
  end
end

puts cheapest_items.inject(0) {|s, i| s + i.cost }
puts most_expensive.inject(0) {|s, i| s + i.cost }
