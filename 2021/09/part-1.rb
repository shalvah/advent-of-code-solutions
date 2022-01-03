$input = File.read(File.join(__dir__, "input.txt")).split("\n").map { |line| line.split("").map(&:to_i) }

def neighbours(x, y)
  below = $input[y + 1][x] rescue nil
  right = $input[y][x + 1] rescue nil
  left = $input[y][x - 1]
  above = $input[y - 1][x]

  [
    (below if y < $input.size - 1),
    (above if y > 0),
    (left if x > 0),
    (right if x < $input[y].size - 1),
  ].compact
end

low_points = $input.flat_map.with_index do |line, y|
  line.filter.with_index do |location, x|
    neighbours(x, y).all? { |neighbour| location < neighbour }
  end
end

p low_points.map { |location| location + 1 }.sum

