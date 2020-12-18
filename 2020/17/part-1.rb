=begin
--- Day 17: Conway Cubes ---
As your flight slowly drifts through the sky, the Elves at the Mythical Information Bureau at the North Pole contact you. They'd like some help debugging a malfunctioning experimental energy source aboard one of their super-secret imaging satellites.

The experimental energy source is based on cutting-edge technology: a set of Conway Cubes contained in a pocket dimension! When you hear it's having problems, you can't help but agree to take a look.

The pocket dimension contains an infinite 3-dimensional grid. At every integer 3-dimensional coordinate (x,y,z), there exists a single cube which is either active or inactive.

In the initial state of the pocket dimension, almost all cubes start inactive. The only exception to this is a small flat region of cubes (your puzzle input); the cubes in this region start in the specified active (#) or inactive (.) state.

The energy source then proceeds to boot up by executing six cycles.

Each cube only ever considers its neighbors: any of the 26 other cubes where any of their coordinates differ by at most 1. For example, given the cube at x=1,y=2,z=3, its neighbors include the cube at x=2,y=2,z=2, the cube at x=0,y=2,z=3, and so on.

During a cycle, all cubes simultaneously change their state according to the following rules:

If a cube is active and exactly 2 or 3 of its neighbors are also active, the cube remains active. Otherwise, the cube becomes inactive.
If a cube is inactive but exactly 3 of its neighbors are active, the cube becomes active. Otherwise, the cube remains inactive.
The engineers responsible for this experimental energy source would like you to simulate the pocket dimension and determine what the configuration of cubes should be at the end of the six-cycle boot process.

For example, consider the following initial state:

.#.
..#
###
Even though the pocket dimension is 3-dimensional, this initial state represents a small 2-dimensional slice of it. (In particular, this initial state defines a 3x3x1 region of the 3-dimensional space.)

Simulating a few cycles from this initial state produces the following configurations, where the result of each cycle is shown layer-by-layer at each given z coordinate (and the frame of view follows the active cells in each cycle):

Before any cycles:

z=0
.#.
..#
###


After 1 cycle:

z=-1
#..
..#
.#.

z=0
#.#
.##
.#.

z=1
#..
..#
.#.


After 2 cycles:

z=-2
.....
.....
..#..
.....
.....

z=-1
..#..
.#..#
....#
.#...
.....

z=0
##...
##...
#....
....#
.###.

z=1
..#..
.#..#
....#
.#...
.....

z=2
.....
.....
..#..
.....
.....


After 3 cycles:

z=-2
.......
.......
..##...
..###..
.......
.......
.......

z=-1
..#....
...#...
#......
.....##
.#...#.
..#.#..
...#...

z=0
...#...
.......
#......
.......
.....##
.##.#..
...#...

z=1
..#....
...#...
#......
.....##
.#...#.
..#.#..
...#...

z=2
.......
.......
..##...
..###..
.......
.......
.......
After the full six-cycle boot process completes, 112 cubes are left in the active state.

Starting with your given initial configuration, simulate six cycles. How many cubes are left in the active state after the sixth cycle?
=end

$actives = {0 => {}}
x_bounds = {max: 0, min: 0}
y_bounds = {max: 0, min: 0}
z_bounds = {max: 0, min: 0}

File.readlines("input.txt").each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    if char == "#"
      $actives[0][y] ||= {}
      $actives[0][y][x] = true

      x_bounds[:max] = x if x > x_bounds[:max]
      x_bounds[:min] = x if x < x_bounds[:min]
    end
  end
  y_bounds[:max] = y if y > y_bounds[:max]
  y_bounds[:min] = y if y < y_bounds[:min]
end

def get_cube_status(x, y, z)
  if ($actives[z][y][x] rescue false) == true
    :active
  else
    :inactive
  end
end

def get_active_neighbours(x, y, z)
  active_neighbours = []
  (z - 1..z + 1).each do |current_z|
    (y - 1..y + 1).each do |current_y|
      (x - 1..x + 1).each do |current_x|
        next if [x, y, z] == [current_x, current_y, current_z]

        if get_cube_status(current_x, current_y, current_z) == :active
          active_neighbours << [current_x, current_y, current_z]
        end
      end
    end
  end
  active_neighbours
end


6.times do
  z_bounds[:max] += 1
  z_bounds[:min] -= 1
  x_bounds[:max] += 1
  x_bounds[:min] -= 1
  y_bounds[:max] += 1
  y_bounds[:min] -= 1

  next_state = Marshal.load(Marshal.dump($actives))
  (z_bounds[:min]..z_bounds[:max]).each do |z|
    (y_bounds[:min]..y_bounds[:max]).each do |y|
      (x_bounds[:min]..x_bounds[:max]).each do |x|
        cube_status = get_cube_status(x, y, z)
        active_neighbours = get_active_neighbours(x, y, z)
        case cube_status
        when :active
          next_state[z][y][x] = nil unless (active_neighbours.size == 2 || active_neighbours.size == 3)
        when :inactive
          if active_neighbours.size == 3
            next_state[z] ||= {}
            next_state[z][y] ||= {}
            next_state[z][y][x] = true
          end
        end
      end
    end
  end
  $actives = next_state
end


def count_active(actives, x_bounds, y_bounds, z_bounds)
  active_count = 0
  (z_bounds[:min]..z_bounds[:max]).each do |z|
    (y_bounds[:min]..y_bounds[:max]).each do |y|
      (x_bounds[:min]..x_bounds[:max]).each do |x|
        active = (actives[z][y][x] rescue false) == true
        active_count += 1 if active
      end
    end
  end
  active_count
end

def print_grid(actives, x_bounds, y_bounds, z_bounds)
  (z_bounds[:min]..z_bounds[:max]).each do |z|
    print "z = #{z}\n"
    (y_bounds[:min]..y_bounds[:max]).each do |y|
      (x_bounds[:min]..x_bounds[:max]).each do |x|
        active = (actives[z][y][x] rescue false) == true
        print(active ? '#' : '.')
      end
      print "\n"
    end
    print "\n"
  end
  print "\n\n"
end

# print_grid($actives, x_bounds, y_bounds, z_bounds)
p count_active($actives, x_bounds, y_bounds, z_bounds)
