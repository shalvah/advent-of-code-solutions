=begin
--- Day 10: Monitoring Station ---
You fly into the asteroid belt and reach the Ceres monitoring station. The Elves here have an emergency: they're having trouble tracking all of the asteroids and can't be sure they're safe.

The Elves would like to build a new monitoring station in a nearby area of space; they hand you a map of all of the asteroids in that region (your puzzle input).

The map indicates whether each position is empty (.) or contains an asteroid (#). The asteroids are much smaller than they appear on the map, and every asteroid is exactly in the center of its marked position. The asteroids can be described with X,Y coordinates where X is the distance from the left edge and Y is the distance from the top edge (so the top-left corner is 0,0 and the position immediately to its right is 1,0).

Your job is to figure out which asteroid would be the best place to build a new monitoring station. A monitoring station can detect any asteroid to which it has direct line of sight - that is, there cannot be another asteroid exactly between them. This line of sight can be at any angle, not just lines aligned to the grid or diagonally. The best location is the asteroid that can detect the largest number of other asteroids.

For example, consider the following map:

.#..#
.....
#####
....#
...##
The best location for a new monitoring station on this map is the highlighted asteroid at 3,4 because it can detect 8 asteroids, more than any other location. (The only asteroid it cannot detect is the one at 1,0; its view of this asteroid is blocked by the asteroid at 2,2.) All other asteroids are worse locations; they can detect 7 or fewer other asteroids. Here is the number of other asteroids a monitoring station on each asteroid could detect:

.7..7
.....
67775
....7
...87
Here is an asteroid (#) and some examples of the ways its line of sight might be blocked. If there were another asteroid at the location of a capital letter, the locations marked with the corresponding lowercase letter would be blocked and could not be detected:

#.........
...A......
...B..a...
.EDCG....a
..F.c.b...
.....c....
..efd.c.gb
.......c..
....f...c.
...e..d..c
Here are some larger examples:

Best is 5,8 with 33 other asteroids detected:

......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
Best is 1,2 with 35 other asteroids detected:

#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###.
Best is 6,3 with 41 other asteroids detected:

.#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#..
Best is 11,13 with 210 other asteroids detected:

.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
Find the best location for a new monitoring station. How many other asteroids can be detected from that location?
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
  asteroids.each_with_index do |location, current_location_index|
    gradients = {}
    asteroids.each_with_index do |other_asteroid, index|
      next if index == current_location_index

      gradient = find_gradient(location, other_asteroid)

      # We need to combine the direction with the gradient
      # to know which side of the current location the asteroid is on
      direction = if index > current_location_index then "before" else "after" end
      gradients[direction + gradient] ||= []
      gradients[direction + gradient] << other_asteroid
    end
    lines_of_sight = gradients.size
    max_lines_of_sight = lines_of_sight if lines_of_sight > max_lines_of_sight
  end
  max_lines_of_sight
end

file = File.open("input.txt")
input = file.read.split
p find_best_location(set_layout(input))
