template, _, *rules = File.read(File.join(__dir__, "input.txt")).split("\n")
$rules = rules.map { |l| l.split(" -> ") }.each_with_object({}) { |rule, all| all[rule[0]] = rule[1] }

pairs = template.split("").each_cons(2).map(&:itself).tally
40.times do
  next_pairs = {}
  pairs.each do |(a, b), freq|
    if (insertion = $rules[a + b])
      next_pairs[[a, insertion]] = (next_pairs[[a, insertion]] || 0) + freq
      next_pairs[[insertion, b]] = (next_pairs[[insertion, b]] || 0) + freq
    end
  end
  pairs = next_pairs
end

character_counts = {}
pairs.each do |(a, b), freq|
  # Only count the first char per pair, to avoid counting chars twice
  character_counts[a] ||= 0
  character_counts[a] += freq
end
character_counts[template[-1]] += 1 # Then add the char at the end

p character_counts.values.max - character_counts.values.min