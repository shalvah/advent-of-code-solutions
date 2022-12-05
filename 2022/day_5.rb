crates, instructions = File.read('day_5.txt').split("\n\n")

$stacks = Hash.new { |hash, key| hash[key] = [] }

crates.split("\n").slice(0..-2).each do |line|
  line.split("").each_slice(4).with_index do |crate, index|
    $stacks[index + 1].unshift(crate[1]) if crate[1] != " "
  end
end

$stacks = $stacks.sort.to_h # Just for easier reading when printed

instructions = instructions.each_line.map do |line|
  line.match(/move (?<count>.+) from (?<source>.+) to (?<destination>.+)/).named_captures
    .map { |k, v| [k.to_sym, v.to_i] }.to_h
end

# Part 1
stacks = $stacks.dup.map { |k, v| [k, v.dup] }.to_h
move = lambda do |instruction|
  instruction => {count:, source:, destination:}
  count.to_i.times { stacks[destination].push(stacks[source].pop) }
end
instructions.each(&move)

p stacks.map { |k, v| v.last }.join


# Part 2
stacks = $stacks.dup.map { |k, v| [k, v.dup] }.to_h
move = lambda do |instruction|
  instruction => {count:, source:, destination:}
  stacks[destination].push(*stacks[source].pop(count))
end

instructions.each(&move)

p stacks.map { |k, v| v.last }.join
