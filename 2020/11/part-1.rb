=begin
--- Day 11: Seating System ---
Your plane lands with plenty of time to spare. The final leg of your journey is a ferry that goes directly to the tropical island where you can finally start your vacation. As you reach the waiting area to board the ferry, you realize you're so early, nobody else has even arrived yet!

By modeling the process people use to choose (or abandon) their seat in the waiting area, you're pretty sure you can predict the best place to sit. You make a quick map of the seat layout (your puzzle input).

The seat layout fits neatly on a grid. Each position is either floor (.), an empty seat (L), or an occupied seat (#). For example, the initial seat layout might look like this:

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
Now, you just need to model the people who will be arriving shortly. Fortunately, people are entirely predictable and always follow a simple set of rules. All decisions are based on the number of occupied seats adjacent to a given seat (one of the eight positions immediately up, down, left, right, or diagonal from the seat). The following rules are applied to every seat simultaneously:

If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
Otherwise, the seat's state does not change.
Floor (.) never changes; seats don't move, and nobody sits on the floor.

After one round of these rules, every seat in the example layout becomes occupied:

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
After a second round, the seats with four or more occupied adjacent seats become empty again:

#.LL.L#.##
#LLLLLL.L#
L.L.L..L..
#LLL.LL.L#
#.LL.LL.LL
#.LLLL#.##
..L.L.....
#LLLLLLLL#
#.LLLLLL.L
#.#LLLL.##
This process continues for three more rounds:

#.##.L#.##
#L###LL.L#
L.#.#..#..
#L##.##.L#
#.##.LL.LL
#.###L#.##
..#.#.....
#L######L#
#.LL###L.L
#.#L###.##
#.#L.L#.##
#LLL#LL.L#
L.L.L..#..
#LLL.##.L#
#.LL.LL.LL
#.LL#L#.##
..L.L.....
#L#LLLL#L#
#.LLLLLL.L
#.#L#L#.##
#.#L.L#.##
#LLL#LL.L#
L.#.L..#..
#L##.##.L#
#.#L.LL.LL
#.#L#L#.##
..L.L.....
#L#L##L#L#
#.LLLLLL.L
#.#L#L#.##
At this point, something interesting happens: the chaos stabilizes and further applications of these rules cause no seats to change state! Once people stop moving around, you count 37 occupied seats.

Simulate your seating area by applying the seating rules repeatedly until no seats change state. How many seats end up occupied?
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

def calculate_new_state(current_coordinates, initial_state, seats_grid)
  number_occupied_adjacent = 0

  if initial_state == "L"
    Directions.each do |dir|
      number_occupied_adjacent += 1 if adjacent_seat_state(current_coordinates, seats_grid, dir) == "#"
    end
    return "#" if number_occupied_adjacent == 0
  end

  if initial_state == "#"
    Directions.each do |dir|
      number_occupied_adjacent += 1 if (adjacent_seat_state(current_coordinates, seats_grid, dir)) == "#"
    end
    return "L" if number_occupied_adjacent >= 4
  end

  initial_state
end

def adjacent_seat_state(coordinates, current_seats_grid, direction)
  # Here, we're considering only what's immediately next to the current position
  # If it's floor or out of bounds return nil
  # Otherwise return the coordinates
  row, column = coordinates
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
    new_state = calculate_new_state(current_coordinates, initial_state, seats_grid)
    new_seats_grid[current_coordinates] = new_state
    state_changed = true if new_state != initial_state
  end
  seats_grid = new_seats_grid
  break if state_changed == false
end

p(seats_grid.count { |coordinates, state| state == "#" })
