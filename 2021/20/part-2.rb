enhancement_algo, input = File.read(File.join(__dir__, "input.txt")).split("\n\n")
input = input.split.map { |line| line.split("") }

def pixel_to_binary(char)
  {
    "." => "0",
    "#" => "1",
  }[char]
end

def surrounding_square(x, y, grid, uninitialized)
  left_above = (x == 0 || y == 0) ? uninitialized : grid[y - 1][x - 1]
  above = y == 0 ? uninitialized : grid[y - 1][x]
  right_above = (x == grid[0].size - 1 || y == 0) ? uninitialized : grid[y - 1][x + 1]
  left = x == 0 ? uninitialized : grid[y][x - 1]
  right = x == grid[0].size - 1 ? uninitialized : grid[y][x + 1]
  left_below = (x == 0 || y == grid.size - 1) ? uninitialized : grid[y + 1][x - 1]
  below = y == grid.size - 1 ? uninitialized : grid[y + 1][x]
  right_below = (x == grid[0].size - 1 || y == grid.size - 1) ? uninitialized : grid[y + 1][x + 1]

  [
    pixel_to_binary(left_above),
    pixel_to_binary(above),
    pixel_to_binary(right_above),
    pixel_to_binary(left),
    pixel_to_binary(grid[y][x]),
    pixel_to_binary(right),
    pixel_to_binary(left_below),
    pixel_to_binary(below),
    pixel_to_binary(right_below),
  ]
end

grid = input
uninitialized = "."

50.times do
  grid.map! do |row|
    row.unshift(uninitialized)
    row.push(uninitialized)
  end
  grid.unshift([uninitialized] * grid[1].size)
  grid.push([uninitialized] * grid[1].size)

  output = grid.map.with_index do |row, y|
    row.map.with_index do |char, x|
      binary_index = surrounding_square(x, y, grid, uninitialized).join
      enhancement_algo[binary_index.to_i(2)]
    end
  end

  grid = output
  uninitialized = enhancement_algo[(pixel_to_binary(uninitialized) * 9).to_i(2)]
end

p grid.flatten.tally["#"]