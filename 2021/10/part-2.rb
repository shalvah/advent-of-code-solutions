input = File.read(File.join(__dir__, "input.txt")).split.map { |line| line.split("") }

closers = {
  "(" => ")",
  "[" => "]",
  "{" => "}",
  "<" => ">",
}

completions = []
input.each do |line|
  opened = []
  line.each do |char|
    if opened.any? && char == closers[opened[-1]] # Matching closing char
      opened.pop
    elsif opened.any? && closers.values.include?(char) # Closing char, but incorrect
      opened = []
      break # Corrupted, discard
    else
      opened << char # Opening char
    end
  end

  if opened.any?
    completions << opened.reverse.map { |char| closers[char] }
  end
end

scores = {
  ")" => 1,
  "]" => 2,
  "}" => 3,
  ">" => 4,
}

completion_scores = completions.map do |completion|
  score = 0
  until completion.empty?
    score *= 5
    score += scores[completion.shift]
  end
  score
end

p completion_scores.sort.at(((completions.size + 1) / 2) - 1)