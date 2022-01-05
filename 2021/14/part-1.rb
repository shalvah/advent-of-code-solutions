template, _, *rules = File.read(File.join(__dir__, "input.txt")).split("\n")
rules = rules.map { |l| l.split(" -> ") }.each_with_object({}) { |rule, all| all[rule[0]] = rule[1] }

state = template.split("")
first_char = state[0]

10.times do
  state = state.each_cons(2).flat_map do |pair|
    insertion = rules[pair.join("")]
    [insertion, pair[1]]
  end
  # To avoid duplicates, we only added the second letter of each pair, so we need to add the first char back
  state.prepend first_char
end

tally = state.tally
p tally.values.max - tally.values.min