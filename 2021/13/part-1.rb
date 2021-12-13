dots, instructions = File.read(File.join(__dir__, "input.txt")).split("\n\n")

require 'set'
dots = dots.split("\n").map { |line| line.split(",").map(&:to_i) }
dots = Set.new(dots)
instructions = instructions.split("\n").map { |line| line.split.at(2).split("=") }

coordinate, value = instructions[0]
value = value.to_i
folded = Set.new
if coordinate == "y"
  dots.each do |(x, y)|
    folded << [x, y < value ? y : value - (y - value)]
  end
else
  dots.each do |(x, y)|
    folded << [x < value ? x : value - (x - value), y]
  end
end

p folded.size