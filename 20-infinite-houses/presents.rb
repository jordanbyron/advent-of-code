require_relative '../advent'

PresentsForHouse = ->(house_number) {
  elf_numbers = Factors[house_number]

  elf_numbers.inject(0) do |s, elf_number|
    s + (elf_number * 10)
  end
}

Factors = ->(number) {
  1.upto(Math.sqrt(number)).select {|i| (number % i).zero?}.inject([]) do |f, i|
    f << number/i unless i == number/i
    f << i
  end
}
