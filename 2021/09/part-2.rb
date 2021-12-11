$input = File.read(File.join(__dir__, "input.txt")).split("\n").map { |line| line.split("").map(&:to_i) }

def neighbours(x, y)
  below = [x, y + 1, $input[y + 1][x]] rescue nil
  right = [x + 1, y, $input[y][x + 1]] rescue nil
  left = [x - 1, y, $input[y][x - 1]] rescue nil
  above = [x, y - 1, $input[y - 1][x]] rescue nil

  [
    (below if y < $input.size - 1),
    (above if y > 0),
    (left if x > 0),
    (right if x < $input[y].size - 1),
  ].compact.filter { |n| n[2] != 9 }
end

low = []
$input.each_with_index do |line, y|
  line.each_with_index do |location, x|
    if neighbours(x, y).all? { |x_n, y_n, neighbour| location < neighbour }
      low << [x, y, location]
    end
  end
end

basins = low.map do |x, y, low_point|
  locations_in_basin = [[x, y, low_point]]
  locations_in_basin.each do |x_n, y_n, location|
    neighbours = neighbours(x_n, y_n).filter { |x_nn, y_nn, n_n| !locations_in_basin.include?([x_nn, y_nn, n_n]) }
    locations_in_basin.push(*neighbours)
  end
  locations_in_basin
end

p basins.map(&:size).max(3).reduce(:*)

=begin

# Recursive version:
require 'set'

def get_basin(x, y, location, basin)
  return basin if basin.include? [x, y, location]

  basin << [x, y, location]

  neighbours = all_neighbours(x, y).filter { |n| n[2] != 9 }
  neighbours.each do |x_n, y_n, neighbour|
    basin = get_basin(x_n, y_n, neighbour, basin)
  end
  basin
end

basins = low.map do |x, y, location|
  get_basin(x, y, location, Set.new)
end

p basins.map(&:size).max(3).reduce(:*)

=end