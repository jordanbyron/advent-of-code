require_relative '../advent'

AuntParser = ->(inputs) {
  id_regex     = /Sue (?<id>\d+):/
  attrib_regex = /(?<attribute>\S+): (?<value>\d+)/

  inputs.map do |input|
    id   = id_regex.match(input)[:id]
    aunt = {'id' => id}

    input.scan(attrib_regex).each do |name, value|
      aunt[name] = value.to_i
    end

    aunt
  end
}

aunts = AuntParser[@input.split("\n")]
desired_attributes = {
  'children' => 3,
  'cats' => 7,
  'samoyeds' => 2,
  'pomeranians' => 3,
  'akitas' => 0,
  'vizslas' => 0,
  'goldfish' => 5,
  'trees' => 3,
  'cars' => 2,
  'perfumes' => 1
}

PartOneAuntMatcher = ->(desired_attributes, aunts) {
  best_match = {}

  aunts.each do |aunt|
    match = aunt.all? do |k, v|
      next true if k == 'id'
      desired_attributes[k] == v
    end

    if match && best_match.keys.length < aunt.keys.length
      # This aunt has more matches, she is the best match currently found
      best_match = aunt
    end
  end

  best_match
}

PartTwoAuntMatcher = ->(desired_attributes, aunts) {
  best_match = {}

  aunts.each do |aunt|
    match = aunt.all? do |k, v|
      next true if k == 'id'

      if ['trees', 'cats'].include?(k)
        v > desired_attributes[k]
      elsif ['pomeranians', 'goldfish'].include?(k)
        v < desired_attributes[k]
      else
        desired_attributes[k] == v
      end
    end

    if match && best_match.keys.length < aunt.keys.length
      # This aunt has more matches, she is the best match currently found
      best_match = aunt
    end
  end

  best_match
}


match = PartTwoAuntMatcher[desired_attributes, aunts]
puts match
