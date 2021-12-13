dots, instructions = File.read(File.join(__dir__, "input.txt")).split("\n\n")

require 'set'
dots = dots.split("\n").map { |line| line.split(",").map(&:to_i) }
dots = Set.new(dots)
instructions = instructions.split("\n").map { |line| line.split.at(2).split("=") }

instructions.each do |(coordinate, value)|
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
  dots = folded
end

grid = dots.each_with_object([]) do |(x, y), grid|
  grid[y] ||= []
  grid[y][x] = "#"
end

output = grid.map do |line|
  line.map { |dot| dot ? dot : '.' }.join("")
end.join("\n")

print output
