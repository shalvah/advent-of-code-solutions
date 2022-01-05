template, _, *rules = File.read(File.join(__dir__, "input.txt")).split("\n")
$rules = rules.map { |l| l.split(" -> ") }.each_with_object({}) { |rule, all| all[rule[0]] = rule[1] }

# What matters isn't the string itself, but the pairs in the string 😉
pairs = template.split("").each_cons(2).tally
40.times do
  pairs = pairs.each_with_object({}) do |((a, b), freq), next_pairs|
    insertion = $rules[a + b]
    next_pairs[[a, insertion]] = (next_pairs[[a, insertion]] || 0) + freq
    next_pairs[[insertion, b]] = (next_pairs[[insertion, b]] || 0) + freq
  end
end

character_counts = pairs.each_with_object({}) do |((a, b), freq), counts|
  # Only count the last char per pair, to avoid counting chars twice
  counts[b] = (counts[b] || 0) + freq
end
character_counts[template[0]] += 1 # Then add the char at the start

p character_counts.values.max - character_counts.values.min