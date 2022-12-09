movements = File.readlines('day_9.txt').map { |line| line.split(' ') }

$head_position = [0, 0]
$tail_position = [0, 0]

# R = +x = ->
# U = +y = ^

touching = lambda do |point_1, point_2|
  return (point_1[0] - point_2[0]).abs <= 1 && (point_1[1] - point_2[1]).abs <= 1
  # Longer version:
  # return true if point_1 == point_2
  # return true if point_1[0] == point_2[0] && (point_1[1] - point_2[1]).abs == 1 # Touching up and down
  # return true if point_1[1] == point_2[1] && (point_1[0] - point_2[0]).abs == 1 # TOuching sideways
  # return true if (point_1[0] - point_2[0]).abs == 1 && (point_1[1] - point_2[1]).abs == 1 # TOuching diagonally
end

# Part 1
$all_positions_tail_visited = {}
move = lambda do |(direction, count)|
  count.to_i.times do
    previous_head_position = $head_position.dup

    case direction
      when "R"; $head_position[0] += 1
      when "L"; $head_position[0] -= 1
      when "U"; $head_position[1] += 1
      when "D"; $head_position[1] -= 1
    end

    # The tail simply needs to go to head's previous position
    $tail_position = previous_head_position unless touching.($head_position, $tail_position)
    $all_positions_tail_visited[$tail_position] = true
  end
end

movements.each(&move)

p $all_positions_tail_visited.size


# Part 2
$head_position = [0, 0]
$knots = 9.times.map { [0, 0] } # Knot 8 is the tail

$all_positions_tail_visited = {}

move = lambda do |(direction, count)|
  count.to_i.times do
    previous_head_position = $head_position.dup

    case direction
      when "R"; $head_position[0] += 1
      when "L"; $head_position[0] -= 1
      when "U"; $head_position[1] += 1
      when "D"; $head_position[1] -= 1
    end

    $knots.map!.with_index do |position, i|
      previous_knot = i == 0 ? $head_position : $knots[i - 1]
      if touching.(previous_knot, position)
        position
      else
        case true
          when i == 0 # The first knot moves to the head's previous position
            previous_head_position
          when previous_knot[0] == position[0] # Move vertically
            gap = previous_knot[1] > position[1] ? 1 : -1
            [position[0], position[1] + gap]
          when previous_knot[1] == position[1] # Move sideways
            gap = previous_knot[0] > position[0] ? 1 : -1
            [position[0] + gap, position[1]]
          else # Move diagonally
            gap_x = previous_knot[0] > position[0] ? 1 : -1
            gap_y = previous_knot[1] > position[1] ? 1 : -1
            [position[0] + gap_x, position[1] + gap_y]
        end
      end
    end

    $all_positions_tail_visited[$knots.last] = true
  end
end

movements.each(&move)

p $all_positions_tail_visited.size


def visualize(knots)
  max_x = knots.map(&:first).max
  min_x = (knots.map(&:first) + [0]).min
  max_y = knots.map(&:last).max
  min_y = (knots.map(&:last) + [0]).min

  # Normalize to 0-based
  offsets = [min_x >= 0 ? min_x : -min_x, min_y >= 0 ? min_y : -min_y]
  knots = knots.map do |(x, y)|
    [x + offsets[0], y + offsets[1]]
  end
  max_x += offsets[0]
  max_y += offsets[1]

  grid = (min_y..max_y).map { (min_x..max_x).map { '.' }}
  knots.each_with_index do |(x, y), i|
    next if grid[y][x] == 'H' || (grid[y][x].is_a?(Integer) && grid[y][x] < i)
    grid[y][x] = i == 0 ? 'H' : i
  end

  puts "\n"
  grid.each { puts _1.join }
end

visualize([$head_position] + $knots)
visualize($all_positions_tail_visited.keys)
