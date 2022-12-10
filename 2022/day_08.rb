grid = File.read('day_08.txt').split.map { _1.split('').map(&:to_i) }

# grid.each { p _1 }
# puts "\n"

# x ->
# y ^

# Part 1
visible = {}

grid.each_with_index do |row, y|
  # from left
  highest_tree_height = 0
  row.each_with_index do |tree_height, x|
    if x == 0
      highest_tree_height = visible[[x, y]] = tree_height
      next
    end

    next if highest_tree_height >= tree_height

    highest_tree_height = visible[[x, y]] = tree_height
  end

  # from right
  highest_tree_height = 0
  row.reverse_each.with_index do |tree_height, x|
    if x == 0
      highest_tree_height = visible[[row.size - x - 1, y]] = tree_height
      next
    end

    next if highest_tree_height >= tree_height

    highest_tree_height = visible[[row.size - x - 1, y]] = tree_height
  end
end

grid.transpose.each_with_index do |column, x|
  # from top
  highest_tree_height = 0
  column.each_with_index do |tree_height, y|
    if y == 0
      highest_tree_height = visible[[x, y]] = tree_height
      next
    end

    next if highest_tree_height >= tree_height

    highest_tree_height = visible[[x, y]] = tree_height
  end

  # from bottom
  highest_tree_height = 0
  column.reverse_each.with_index do |tree_height, y|
    if y == 0
      highest_tree_height = visible[[x, grid.size - y - 1]] = tree_height
      next
    end

    next if highest_tree_height >= tree_height

    highest_tree_height = visible[[x, grid.size - y - 1]] = tree_height
  end
end

# pp visible.sort_by { |k, v| k.reverse }.to_h
p visible.count


# Part 2
viewing_distances = Hash.new do |h, k|
  h[k] = { '+x' => 0, '+y' => 0, '-x' => 0, '-y' => 0, value: grid[k[1]][k[0]] }
end

# The viewing distance for each tree is just the number of trees visible in each direction.
# So we find the index of the first blocking tree (height >= current tree height) in each direction
# and find the difference with the current index.
# We can do that efficiently by storing the grid as a list of all occurrences mapped to locations.
# Then, since we know every tree height is between 0-9, we can look up only the heights larger than ours
# and find the nearest occurrence. Boom!

occurrences_horizontal = {}
grid.each_with_index do |row, y|
  row.each_with_index do |tree_height, x|
    occurrences_horizontal[y] ||= {}
    occurrences_horizontal[y][tree_height] ||= []
    occurrences_horizontal[y][tree_height] << x
  end
end

grid.each_with_index do |row, y|
  # left and right
  row.each_with_index do |tree_height, x|
    indexes = (tree_height..9).map do |height|
      first_left = occurrences_horizontal[y][height]&.filter { |index| index < x }&.max # Or .filter(&x.method(:>))
      first_right = occurrences_horizontal[y][height]&.filter { |index| index > x }&.min
      [first_left, first_right]
    end

    leftwards_index = indexes.map(&:first).compact.max || 0
    rightwards_index = indexes.map(&:last).compact.min || (row.size - 1)

    viewing_distances[[x, y]]['+x'] = x - leftwards_index
    viewing_distances[[x, y]]['-x'] = rightwards_index - x
  end
end

occurrences_vertical = {}
grid.transpose.each_with_index do |column, x|
  column.each_with_index do |tree_height, y|
    occurrences_vertical[x] ||= {}
    occurrences_vertical[x][tree_height] ||= []
    occurrences_vertical[x][tree_height] << y
  end
end

grid.transpose.each_with_index do |column, x|
  # up and down
  column.each_with_index do |tree_height, y|
    indexes = (tree_height..9).map do |height|
      first_up = occurrences_vertical[x][height]&.filter { |index| index < y }&.max
      first_down = occurrences_vertical[x][height]&.filter { |index| index > y }&.min
      [first_up, first_down]
    end

    upwards_index = indexes.map(&:first).compact.max || 0
    downwards_index = indexes.map(&:last).compact.min || (grid.size - 1)

    viewing_distances[[x, y]]['-y'] = y - upwards_index
    viewing_distances[[x, y]]['+y'] = downwards_index - y
  end
end

# pp viewing_distances.map { |k, v| [k, v.except(:value).values.reduce(:*)] }.to_h
pp viewing_distances.map { |k, v| v.except(:value).values.reduce(:*) }.max
