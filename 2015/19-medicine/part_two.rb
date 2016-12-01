require_relative 'common'

ordered_replacements = @replacements.select do |to, from|
  to != 'e'
end.sort_by {|to, from| from.length }.reverse

electron_replacements = @replacements.select do |to, from|
  to == 'e'
end.map {|to, from| from }

MoleculeReducer = ->(molecule, step) {
  puts "Step: #{step} => #{molecule}"

  if electron_replacements.include?(molecule)
    molecule = 'e'
    raise step
  end

  ordered_replacements.each do |to, from|
    molecule.match(from) do |m|
      new_molecule = molecule.clone
      new_molecule[m.begin(0)..m.end(0)-1] = to
      MoleculeReducer[new_molecule, step + 1]
    end
  end
}

puts MoleculeReducer[@molecule, 1]
