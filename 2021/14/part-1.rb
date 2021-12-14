template, _, *rules = File.read(File.join(__dir__, "input.txt")).split("\n")
rules = rules.map { |l| l.split(" -> ") }.each_with_object({}) { |rule, all| all[rule[0]] = rule[1] }

state = template.split("")

10.times do
  next_state = []
  next_state.push(state[0])
  state.each_cons(2) do |pair|
    insertion = rules[pair.join("")]
    next_state.push(insertion) if insertion
    next_state.push(pair[1])
  end

  state = next_state
end

tally = state.tally
p tally.values.max - tally.values.min

=begin
def get_next_pairs(pair)
  insertion = $rules["#{pair.join("")}"]
  [[pair[0], insertion], [insertion, pair[1]]]
end

next_state = state.flat_map.with_index do |char, index|
  next if index === state.size - 1

  pairs = [[char, state[index + 1]]]

  40.times do
    pairs = pairs.flat_map { |p| get_next_pairs(p) }
  end
  pairs.map { |p| p[1] }.join
end

p state[0] + next_state.join
=end