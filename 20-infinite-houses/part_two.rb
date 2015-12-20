require_relative 'presents'

elves = Hash.new(0)

PresentsForHouse = ->(house_number) {
  elf_numbers = Factors[house_number]

  elf_numbers.inject(0) do |s, elf_number|
    if elves[elf_number] < 50
      elves[elf_number] += 1
      s + (elf_number * 11)
    else
      s
    end
  end
}

input = 33100000
house_number = 0
presents = 0

until(presents >= input)
  house_number += 1
  presents = PresentsForHouse[house_number]
  puts house_number if (house_number % 1000 == 0)
end

puts house_number
