begin
--- Part Two ---
As soon as people start to arrive, you realize your mistake. People don't just care about adjacent seats - they care about the first seat they can see in each of those eight directions!

Now, instead of considering just the eight immediately adjacent seats, consider the first seat in each of those eight directions. For example, the empty seat below would see eight occupied seats:

.......#.
...#.....
.#.......
.........
..#L....#
....#....
.........
#........
...#.....
The leftmost empty seat below would only see one empty seat, but cannot see any of the occupied ones:

.............
.L.L.#.#.#.#.
.............
The empty seat below would see no occupied seats:

.##.##.
#.#.#.#
##...##
...L...
##...##
#.#.#.#
.##.##.
Also, people seem to be more tolerant than you expected: it now takes five or more visible occupied seats for an occupied seat to become empty (rather than four or more from the previous rules). The other rules still apply: empty seats that see no occupied seats become occupied, seats matching no rule don't change, and floor never changes.

Given the same starting layout as above, these new rules cause the seating area to shift around as follows:

L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
#.##.##.##
#######.##
#.#.#..#..
####.##.##
#.##.##.##
#.#####.##
..#.#.....
##########
#.######.#
#.#####.##
#.LL.LL.L#
#LLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLL#
#.LLLLLL.L
#.LLLLL.L#
#.L#.##.L#
#L#####.LL
L.#.#..#..
##L#.##.##
#.##.#L.##
#.#####.#L
..#.#.....
LLL####LL#
#.L#####.L
#.L####.L#
#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##LL.LL.L#
L.LL.LL.L#
#.LLLLL.LL
..L.L.....
LLLLLLLLL#
#.LLLLL#.L
#.L#LL#.L#
#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.#L.L#
#.L####.LL
..#.#.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#
#.L#.L#.L#
#LLLLLL.LL
L.L.L..#..
##L#.#L.L#
L.L#.LL.L#
#.LLLL#.LL
..#.L.....
LLL###LLL#
#.LLLLL#.L
#.L#LL#.L#
Again, at this point, people stop shifting around and the seating area reaches equilibrium. Once this occurs, you count 26 occupied seats.

Given the new visibility method and the rule change for occupied seats becoming empty, once equilibrium is reached, how many seats end up occupied?
=end

Directions = [
    :up,
    :down,
    :left,
    :right,
    :up_left,
    :up_right,
    :down_left,
    :down_right,
]

def calculate_new_state(current_coordinates, initial_state, seats_grid, row_count, column_count)
  number_occupied_adjacent = 0

  if initial_state == "L"
    Directions.each do |dir|
      number_occupied_adjacent += 1 if adjacent_seat_state(current_coordinates, seats_grid, dir, row_count, column_count) == "#"
    end
    return "#" if number_occupied_adjacent == 0
  end

  if initial_state == "#"
    Directions.each do |dir|
      number_occupied_adjacent += 1 if (adjacent_seat_state(current_coordinates, seats_grid, dir, row_count, column_count)) == "#"
    end
    return "L" if number_occupied_adjacent >= 5
  end

  initial_state
end

def adjacent_seat_state(coordinates, current_seats_grid, direction, row_count, column_count)
  row, column = coordinates
  while row >= 0 && row < row_count &&
      column >= 0 && column < column_count
    # Stop if point is off the grid
    case direction
    when :up
      row -= 1
    when :down
      row += 1
    when :left
      column -= 1
    when :right
      column += 1
    when :up_left
      row -= 1
      column -= 1
    when :up_right
      row -= 1
      column += 1
    when :down_left
      row += 1
      column -= 1
    when :down_right
      row += 1
      column += 1
    end
    adjacent = current_seats_grid[[row, column]]
    if adjacent == nil # Either floor or nothing
      next # Let the loop handle it
    else
      return adjacent #Ladies and gentlemen, we have a seat! 👏👏
    end
  end

  nil
end

file = File.open("input.txt")
input = file.read.split

full_grid = {}
seats_grid = {}
input.each_with_index do |line, row|
  line.each_char.with_index do |char, column|
    seats_grid[[row, column]] = char if char != "."
  end
end
row_count = input.size
column_count = input[0].size

loop do
  state_changed = false
  new_seats_grid = {}
  seats_grid.each do |current_coordinates, initial_state|
    new_state = calculate_new_state(current_coordinates, initial_state, seats_grid, row_count, column_count)
    new_seats_grid[current_coordinates] = new_state
    state_changed = true if new_state != initial_state
  end
  seats_grid = new_seats_grid
  break if state_changed == false
end

p(seats_grid.count { |coordinates, state| state == "#" })
