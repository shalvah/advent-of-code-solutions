=begin
--- Part Two ---
For some reason, your simulated results don't match what the experimental energy source engineers expected. Apparently, the pocket dimension actually has four spatial dimensions, not three.

The pocket dimension contains an infinite 4-dimensional grid. At every integer 4-dimensional coordinate (x,y,z,w), there exists a single cube (really, a hypercube) which is still either active or inactive.

Each cube only ever considers its neighbors: any of the 80 other cubes where any of their coordinates differ by at most 1. For example, given the cube at x=1,y=2,z=3,w=4, its neighbors include the cube at x=2,y=2,z=3,w=3, the cube at x=0,y=2,z=3,w=4, and so on.

The initial state of the pocket dimension still consists of a small flat region of cubes. Furthermore, the same rules for cycle updating still apply: during each cycle, consider the number of active neighbors of each cube.

For example, consider the same initial state as in the example above. Even though the pocket dimension is 4-dimensional, this initial state represents a small 2-dimensional slice of it. (In particular, this initial state defines a 3x3x1x1 region of the 4-dimensional space.)

Simulating a few cycles from this initial state produces the following configurations, where the result of each cycle is shown layer-by-layer at each given z and w coordinate:

Before any cycles:

z=0, w=0
.#.
..#
###


After 1 cycle:

z=-1, w=-1
#..
..#
.#.

z=0, w=-1
#..
..#
.#.

z=1, w=-1
#..
..#
.#.

z=-1, w=0
#..
..#
.#.

z=0, w=0
#.#
.##
.#.

z=1, w=0
#..
..#
.#.

z=-1, w=1
#..
..#
.#.

z=0, w=1
#..
..#
.#.

z=1, w=1
#..
..#
.#.


After 2 cycles:

z=-2, w=-2
.....
.....
..#..
.....
.....

z=-1, w=-2
.....
.....
.....
.....
.....

z=0, w=-2
###..
##.##
#...#
.#..#
.###.

z=1, w=-2
.....
.....
.....
.....
.....

z=2, w=-2
.....
.....
..#..
.....
.....

z=-2, w=-1
.....
.....
.....
.....
.....

z=-1, w=-1
.....
.....
.....
.....
.....

z=0, w=-1
.....
.....
.....
.....
.....

z=1, w=-1
.....
.....
.....
.....
.....

z=2, w=-1
.....
.....
.....
.....
.....

z=-2, w=0
###..
##.##
#...#
.#..#
.###.

z=-1, w=0
.....
.....
.....
.....
.....

z=0, w=0
.....
.....
.....
.....
.....

z=1, w=0
.....
.....
.....
.....
.....

z=2, w=0
###..
##.##
#...#
.#..#
.###.

z=-2, w=1
.....
.....
.....
.....
.....

z=-1, w=1
.....
.....
.....
.....
.....

z=0, w=1
.....
.....
.....
.....
.....

z=1, w=1
.....
.....
.....
.....
.....

z=2, w=1
.....
.....
.....
.....
.....

z=-2, w=2
.....
.....
..#..
.....
.....

z=-1, w=2
.....
.....
.....
.....
.....

z=0, w=2
###..
##.##
#...#
.#..#
.###.

z=1, w=2
.....
.....
.....
.....
.....

z=2, w=2
.....
.....
..#..
.....
.....
After the full six-cycle boot process completes, 848 cubes are left in the active state.

Starting with your given initial configuration, simulate six cycles in a 4-dimensional space. How many cubes are left in the active state after the sixth cycle?
=end

$actives = {0 => {0 => {}}}
x_bounds = {max: 0, min: 0}
y_bounds = {max: 0, min: 0}
z_bounds = {max: 0, min: 0}
w_bounds = {max: 0, min: 0}

File.readlines("input.txt").each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    if char == "#"
      $actives[0][0][y] ||= {}
      $actives[0][0][y][x] = true

      x_bounds[:max] = x if x > x_bounds[:max]
      x_bounds[:min] = x if x < x_bounds[:min]
    end
  end
  y_bounds[:max] = y if y > y_bounds[:max]
  y_bounds[:min] = y if y < y_bounds[:min]
end

def get_cube_status(x, y, z, w)
  if ($actives[w][z][y][x] rescue false) == true
    :active
  else
    :inactive
  end
end

def get_active_neighbours(x, y, z, w)
  active_neighbours = []
  (w - 1..w + 1).each do |current_w|
    (z - 1..z + 1).each do |current_z|
      (y - 1..y + 1).each do |current_y|
        (x - 1..x + 1).each do |current_x|
          next if [x, y, z, w] == [current_x, current_y, current_z, current_w]

          if get_cube_status(current_x, current_y, current_z, current_w) == :active
            active_neighbours << [current_x, current_y, current_z, current_w]
          end
        end
      end
    end
  end
  active_neighbours
end


6.times do
  w_bounds[:max] += 1
  w_bounds[:min] -= 1
  z_bounds[:max] += 1
  z_bounds[:min] -= 1
  x_bounds[:max] += 1
  x_bounds[:min] -= 1
  y_bounds[:max] += 1
  y_bounds[:min] -= 1

  next_state = Marshal.load(Marshal.dump($actives))
  (w_bounds[:min]..w_bounds[:max]).each do |w|
    (z_bounds[:min]..z_bounds[:max]).each do |z|
      (y_bounds[:min]..y_bounds[:max]).each do |y|
        (x_bounds[:min]..x_bounds[:max]).each do |x|
          cube_status = get_cube_status(x, y, z, w)
          active_neighbours = get_active_neighbours(x, y, z, w)
          case cube_status
          when :active
            next_state[w][z][y][x] = nil unless (active_neighbours.size == 2 || active_neighbours.size == 3)
          when :inactive
            if active_neighbours.size == 3
              next_state[w] ||= {}
              next_state[w][z] ||= {}
              next_state[w][z][y] ||= {}
              next_state[w][z][y][x] = true
            end
          end
        end
      end
    end
  end
  $actives = next_state
end


def count_active(actives, x_bounds, y_bounds, z_bounds, w_bounds)
  active_count = 0
  (w_bounds[:min]..w_bounds[:max]).each do |w|
    (z_bounds[:min]..z_bounds[:max]).each do |z|
      (y_bounds[:min]..y_bounds[:max]).each do |y|
        (x_bounds[:min]..x_bounds[:max]).each do |x|
          active = (actives[w][z][y][x] rescue false) == true
          active_count += 1 if active
        end
      end
    end
  end
  active_count
end

def print_grid(actives, x_bounds, y_bounds, z_bounds, w_bounds)
  (w_bounds[:min]..w_bounds[:max]).each do |w|
    (z_bounds[:min]..z_bounds[:max]).each do |z|
      print "z = #{z}, w = #{w}\n"
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
end

# print_grid($actives, x_bounds, y_bounds, z_bounds, w_bounds)
p count_active($actives, x_bounds, y_bounds, z_bounds, w_bounds)
