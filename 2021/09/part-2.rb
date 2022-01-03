$input = File.read(File.join(__dir__, "input.txt")).split("\n").map { |line| line.split("").map(&:to_i) }

def neighbours(x, y)
  below = [x, y + 1, $input[y + 1][x]] rescue nil
  right = [x + 1, y, $input[y][x + 1]] rescue nil
  left = [x - 1, y, $input[y][x - 1]]
  above = [x, y - 1, $input[y - 1][x]]

  [
    (below if y < $input.size - 1),
    (above if y > 0),
    (left if x > 0),
    (right if x < $input[y].size - 1),
  ].compact.filter { |n| n[2] != 9 }
end

$low_points = []
$input.each_with_index do |line, y|
  line.each_with_index do |location, x|
    if neighbours(x, y).all? { |x_n, y_n, neighbour| location < neighbour }
      $low_points << [x, y, location]
    end
  end
end

def iterative_version
  basins = $low_points.map do |x, y, low_point|
    locations_in_basin = [[x, y, low_point]]
    locations_in_basin.each do |x_n, y_n, location|
      neighbours = neighbours(x_n, y_n).filter { |*neighbour| !locations_in_basin.include?(*neighbour) }
      locations_in_basin.push(*neighbours)
    end
    locations_in_basin
  end
end

def recursive_version
  require 'set'

  def get_surrounding_basin(x, y, location, visited_points = [])
    neighbours = neighbours(x, y) - visited_points

    neighbours_basins = Set.new(neighbours)
    neighbours.each do |x_n, y_n, location_n|
      visited_points << [x_n, y_n, location_n]
      neighbours_basins = neighbours_basins.merge(get_surrounding_basin(x_n, y_n, location_n, visited_points))
    end
    neighbours_basins
  end

  basins = $low_points.map do |x, y, location|
    basin = get_surrounding_basin(x, y, location, [[x, y, location]])
    basin << [x, y, location]
  end
end


basins = recursive_version
p basins.map(&:size).max(3).reduce(:*)