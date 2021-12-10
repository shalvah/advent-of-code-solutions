input = File.read(File.join(__dir__, "input.txt")).split.map { |line| line.split("") }

closers = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">",
}

illegals = []
input.each do |line|
  opened = []
  line.each do |char|
    if opened.any? && char == closers[opened[-1]] # Matching closing char
      opened.pop
    elsif opened.any? && closers.values.include?(char) # Closing char, but incorrect
      illegals << char
      break # Discard the corrupted line
    else
      opened << char # Opening char
    end
  end
end

scores = {
  ")" => 3,
  "]" => 57,
  "}" => 1197,
  ">" => 25137,
}
p illegals.tally.map { |char, count| count * scores[char] }.sum

