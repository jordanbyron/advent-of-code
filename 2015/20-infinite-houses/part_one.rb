require_relative 'presents'

describe 'PresentsForHouse' do
  it 'works for house 1' do
    PresentsForHouse[1].must_equal 10
  end

  it 'works for house 4' do
    PresentsForHouse[4].must_equal 70
  end

  it 'works for house 8' do
    PresentsForHouse[8].must_equal 150
  end

  it 'works for house 9' do
    PresentsForHouse[9].must_equal 130
  end
end

input = 33100000
house_number = 0
presents = 0

until(presents >= input)
  house_number += 1
  presents = PresentsForHouse[house_number]
  puts house_number if (house_number % 1000 == 0)
end

puts house_number
