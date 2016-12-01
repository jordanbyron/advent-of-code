require_relative '../advent'

@replacements = @input.split("\n")[0..-3].map do |input|
  regex = /(?<target>\S+) => (?<replacement>\S+)/

  if data = regex.match(input)
    [data[:target], data[:replacement]]
  else
    raise "Unknown replacement '#{input}'"
  end
end

@molecule = @input.split("\n")[-1]
