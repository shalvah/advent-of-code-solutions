=begin
--- Part Two ---
Once you give them the coordinates, the Elves quickly deploy an Instant Monitoring Station to the location and discover the worst: there are simply too many asteroids.

The only solution is complete vaporization by giant laser.

Fortunately, in addition to an asteroid scanner, the new monitoring station also comes equipped with a giant rotating laser perfect for vaporizing asteroids. The laser starts by pointing up and always rotates clockwise, vaporizing any asteroid it hits.

If multiple asteroids are exactly in line with the station, the laser only has enough power to vaporize one of them before continuing its rotation. In other words, the same asteroids that can be detected can be vaporized, but if vaporizing one asteroid makes another one detectable, the newly-detected asteroid won't be vaporized until the laser has returned to the same position by rotating a full 360 degrees.

For example, consider the following map, where the asteroid with the new monitoring station (and laser) is marked X:

.#....#####...#..
##...##.#####..##
##...#...#.#####.
..#.....X...###..
..#.#.....#....##
The first nine asteroids to get vaporized, in order, would be:

.#....###24...#..
##...##.13#67..9#
##...#...5.8####.
..#.....X...###..
..#.#.....#....##
Note that some asteroids (the ones behind the asteroids marked 1, 5, and 7) won't have a chance to be vaporized until the next full rotation. The laser continues rotating; the next nine to be vaporized are:

.#....###.....#..
##...##...#.....#
##...#......1234.
..#.....X...5##..
..#.9.....8....76
The next nine to be vaporized are then:

.8....###.....#..
56...9#...#.....#
34...7...........
..2.....X....##..
..1..............
Finally, the laser completes its first full rotation (1 through 3), a second rotation (4 through 8), and vaporizes the last asteroid (9) partway through its third rotation:

......234.....6..
......1...5.....7
.................
........X....89..
.................
In the large example above (the one with the best monitoring station location at 11,13):

The 1st asteroid to be vaporized is at 11,12.
The 2nd asteroid to be vaporized is at 12,1.
The 3rd asteroid to be vaporized is at 12,2.
The 10th asteroid to be vaporized is at 12,8.
The 20th asteroid to be vaporized is at 16,0.
The 50th asteroid to be vaporized is at 16,9.
The 100th asteroid to be vaporized is at 10,16.
The 199th asteroid to be vaporized is at 9,6.
The 200th asteroid to be vaporized is at 8,2.
The 201st asteroid to be vaporized is at 10,9.
The 299th and final asteroid to be vaporized is at 11,1.
The Elves are placing bets on which will be the 200th asteroid to be vaporized. Win the bet by determining which asteroid that will be; what do you get if you multiply its X coordinate by 100 and then add its Y coordinate? (For example, 8,2 becomes 802.)
=end

# A line passes through two points if they both satisfy the equation y = mx + c
# This means any two points on the line must have gradient m = dy/dx
# This means that, for any two points (x1, y1) and (x2, y2) and origin (a,b), y2-b/x2-a = y1-b/x1-a = m

def find_gradient(origin, other_point)
  deltaY = (other_point[:y] - origin[:y]).to_f
  deltaX = (other_point[:x] - origin[:x]).to_f
  if deltaX === 0
    # Point is in a straight vertical line from origin
    # Can't divide by 0
    return Float::INFINITY.to_s
  end
  (deltaY / deltaX).to_s
end

def set_layout input
  asteroids = []
  input.each_with_index do |line, row|
    width = line.size
    line.each_char.with_index do |char, col|
      if char == "#"
        asteroids << {x: col.to_i, y: row.to_i}
      end
    end
  end
  asteroids
end

def find_best_location asteroids
  max_lines_of_sight = 0
  best_gradients = nil
  best_location = nil
  asteroids.each_with_index do |location, current_location_index|
    gradients = {}
    asteroids.each_with_index do |other_asteroid, index|
      next if index == current_location_index

      gradient = find_gradient(location, other_asteroid)

      # We need to combine the direction with the gradient
      # to know which side of the current location the asteroid is on
      direction = if index > current_location_index then "after" else "before" end
      key = [direction, gradient]
      gradients[key] ||= []
      gradients[key] << other_asteroid
    end
    lines_of_sight = gradients.size
    if lines_of_sight > max_lines_of_sight
      best_location = location
      best_gradients = gradients
      max_lines_of_sight = lines_of_sight
    end
  end
  [best_location, best_gradients, max_lines_of_sight,]
end

def sort_clockwise(lines_of_sight)
  quadrants = [[], [], [], []]
  lines_of_sight.each do |gradient, asteroids|
    # Negative gradients are to the right of the point
    # Positive gradients are to the left of the point
    # Sort order:
    # before, Infinity -> after, -0 -> after, Infinity -> before, +0 -> before, Infinity
    value = if gradient[1] == Float::INFINITY.to_s then Float::INFINITY else Float(gradient[1]) end
    gradient[1] = value
    if gradient[0] == "before" && (value < 0.0 || value == Float::INFINITY)
      # Top-right quadrant
        quadrants[0] << [gradient, asteroids]
    elsif gradient[0] == "after" && (value > 0.0 || value == -0.0)
      # Bottom-right quadrant
      quadrants[1] << [gradient, asteroids]
    elsif gradient[0] == "after" && (value < 0.0 || value == Float::INFINITY)
      # Bottom-left quadrant
      quadrants[2] << [gradient, asteroids]
    elsif gradient[0] == "before" && (value > 0.0 || value == -0.0)
      # Top-left quadrant
      quadrants[3] << [gradient, asteroids]
    end
  end

  q1_path = quadrants[0].sort_by do |(gradient, asteroids)|
      # Top-right quadrant
      # We need Infinity to count as < 0
      if gradient[1] == Float::INFINITY
        [-1.0/0.0]
      else
        [gradient[1]]
      end
    end
  q2_path = quadrants[1].sort_by do |(gradient, asteroids)|
    # Bottom-left quadrant
    [gradient[1]]
  end
  q2_path = quadrants[1].sort_by do |(gradient, asteroids)|
    # Bottom-right quadrant
    [gradient[1]]
  end
  q3_path = quadrants[2].sort_by do |(gradient, asteroids)|
    # Bottom-left quadrant
    [gradient[1]]
  end
  q4_path = quadrants[3].sort_by do |(gradient, asteroids)|
    # Top-left quadrant
    [gradient[1]]
  end

  sorted = q1_path + q2_path + q3_path + q4_path
  sorted.to_h
end

def find_nth_vaporized(sorted_laser_paths, n)
  number_vaporized = 0
  while sorted_laser_paths.size > 0
    sorted_laser_paths.each do |gradient, asteroids|
      vaporized = asteroids.pop
      number_vaporized += 1 if vaporized
      return vaporized if number_vaporized == n
      if asteroids.size == 0
        # No more asteroids in this LoS; remove from orbit
        sorted_laser_paths.delete(gradient)
      else
        sorted_laser_paths[gradient] = asteroids
      end
    end
  end
  number_vaporized
end

file = File.open("input.txt")
input = file.read.split
location, lines_of_sight, max_line_of_sight = find_best_location(set_layout(input))
sorted_laser_paths = sort_clockwise(lines_of_sight)
answer = find_nth_vaporized(sorted_laser_paths, 200)
p answer
p (answer[:x] * 100) + answer[:y]
