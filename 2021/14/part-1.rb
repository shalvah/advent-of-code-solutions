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