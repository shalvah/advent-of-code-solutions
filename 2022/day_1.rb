input = File.read('day_1.txt').split("\n\n")

quantities = input.each.map do |chunk|
  chunk.each_line.map(&:to_i).sum
end

# Part 1
p quantities.max

# Part 2
p quantities.max(3).sum
