require_relative 'common'

Calibrator = ->(molecule, replacements) {
  results = []
  molecule_parts = molecule.scan(/([a-zA-Z][a-z]?|\d)/).flatten

  molecule_parts.each_with_index do |molecule_part, index|
    mutations = replacements.select {|e, _| e == molecule_part }

    if mutations.any?
      mutations.each do |_,mutation|
        new_molecule = ''
        molecule_parts.each_with_index do |molecule_part, yindex|
          new_molecule += if index == yindex
            mutation
          else
            molecule_part
          end
        end
        results << new_molecule
      end
    end
  end

  results
}

describe 'Calibrator' do
  let(:replacements) { [
    ['H', 'HO'], ['H', 'OH'], ['O', 'HH']
  ]}

  it 'determines all possible replacements' do
    results = Calibrator['HOH', replacements]

    results.must_include 'HOOH'
    results.must_include 'HOHO'
    results.must_include 'OHOH'
    results.must_include 'HHHH'

    results.count.must_equal 5

    results.uniq.count.must_equal 4
  end

  it 'works with jolly molecules' do
    results = Calibrator['HOHOHO', replacements]

    results.count.must_equal 9
    results.uniq.count.must_equal 7
  end

  it 'works with water' do
    Calibrator['H2O', [['H', 'OO']]].must_equal ['OO2O']
  end
end

puts Calibrator[@molecule, @replacements].uniq.count
