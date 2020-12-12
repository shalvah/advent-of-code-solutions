=begin
--- Part Two ---
Before you can give the destination to the captain, you realize that the actual action meanings were printed on the back of the instructions the whole time.

Almost all of the actions indicate how to move a waypoint which is relative to the ship's position:

Action N means to move the waypoint north by the given value.
Action S means to move the waypoint south by the given value.
Action E means to move the waypoint east by the given value.
Action W means to move the waypoint west by the given value.
Action L means to rotate the waypoint around the ship left (counter-clockwise) the given number of degrees.
Action R means to rotate the waypoint around the ship right (clockwise) the given number of degrees.
Action F means to move forward to the waypoint a number of times equal to the given value.
The waypoint starts 10 units east and 1 unit north relative to the ship. The waypoint is relative to the ship; that is, if the ship moves, the waypoint moves with it.

For example, using the same instructions as above:

F10 moves the ship to the waypoint 10 times (a total of 100 units east and 10 units north), leaving the ship at east 100, north 10. The waypoint stays 10 units east and 1 unit north of the ship.
N3 moves the waypoint 3 units north to 10 units east and 4 units north of the ship. The ship remains at east 100, north 10.
F7 moves the ship to the waypoint 7 times (a total of 70 units east and 28 units north), leaving the ship at east 170, north 38. The waypoint stays 10 units east and 4 units north of the ship.
R90 rotates the waypoint around the ship clockwise 90 degrees, moving it to 4 units east and 10 units south of the ship. The ship remains at east 170, north 38.
F11 moves the ship to the waypoint 11 times (a total of 44 units east and 110 units south), leaving the ship at east 214, south 72. The waypoint stays 4 units east and 10 units south of the ship.
After these operations, the ship's Manhattan distance from its starting position is 214 + 72 = 286.

Figure out where the navigation instructions actually lead. What is the Manhattan distance between that location and the ship's starting position?
=end

# Wrap a degree value to be within 0 to 360
def wrap_degrees(degrees)
  while degrees <= 0
    degrees += 360
  end

  while degrees > 360
    degrees %= 360
  end
  degrees
end

def translate_point(waypoint, degrees)
  if waypoint[:x] >= 0
    if waypoint[:y] >= 0
      current_quadrant = 1
    else
      current_quadrant = 2
    end
  else
    if waypoint[:y] >= 0
      current_quadrant = 4
    else
      current_quadrant = 3
    end
  end

  rotations = (degrees / 90) % 4
  while rotations > 0
    case current_quadrant
    when 1
      waypoint[:x], waypoint[:y] = [waypoint[:y], -waypoint[:x]]
      current_quadrant = 2
    when 2
      waypoint[:x], waypoint[:y] = [waypoint[:y], -waypoint[:x]]
      current_quadrant = 3
    when 3
      waypoint[:x], waypoint[:y] = [waypoint[:y], -waypoint[:x]]
      current_quadrant = 3
    when 4
      waypoint[:x], waypoint[:y] = [waypoint[:y], -waypoint[:x]]
      current_quadrant = 1
    end
    rotations -= 1
  end
  waypoint
end

def compute_new_positions(action, offset, position, waypoint)
  case action
  when "N" # north
    waypoint[:y] = waypoint[:y] + offset
  when "S" # south
    waypoint[:y] = waypoint[:y] - offset
  when "E" # east
    waypoint[:x] = waypoint[:x] + offset
  when "W" # west
    waypoint[:x] = waypoint[:x] - offset
  when "L" # rotate waypoint counterclockwise around ship
    offset = wrap_degrees(offset)
    waypoint = translate_point(waypoint, 360 - offset)
  when "R" # rotate clockwise
    offset = wrap_degrees(offset)
    waypoint = translate_point(waypoint, offset)
  when "F" # move ship to the waypoint n times
    position[:x] += (offset * waypoint[:x])
    position[:y] += (offset * waypoint[:y])
  end
  # p [action, offset, position, waypoint]
  [position, waypoint]
end


file = File.open("input.txt")
input = file.read.split

ship_position = {x: 0, y: 0}
# Remember that the waypoint is a position (not an object)
# relative to wherever the ship currently is
# So x and y here are really deltas from the ship.
waypoint = {x: 10, y: 1}

input.each do |instruction|
  action = instruction[0]
  offset = instruction[1..-1].to_i

  ship_position, waypoint = compute_new_positions(
      action, offset, ship_position, waypoint
  )
end

p ship_position, waypoint

manhattan_distance = ship_position[:x].abs + ship_position[:y].abs
p manhattan_distance
