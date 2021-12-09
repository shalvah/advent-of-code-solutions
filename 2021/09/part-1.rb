$input = File.read(File.join(__dir__, "input.txt")).split("\n").map { |line| line.split("").map(&:to_i) }

def neighbours(x, y)
  below = $input[y + 1][x] rescue nil
  right = $input[y][x + 1] rescue nil
  left = $input[y][x - 1] rescue nil
  above = $input[y - 1][x] rescue nil

  [
    (below if y.between?(0, $input.size - 2)),
    (above if y.between?(1, $input.size - 1)),
    (left if x.between?(1, $input[y].size - 1)),
    (right if x.between?(0, $input[y].size - 2)),
  ].compact
end

low = []
$input.each_with_index do |line, y|
  line.each_with_index do |location, x|
    if neighbours(x, y).all? { |neighbour| location < neighbour }
      low << location
    end
  end
end

p low.map { |location| location + 1 }.sum

