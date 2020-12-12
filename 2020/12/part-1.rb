=begin
--- Day 12: Rain Risk ---
Your ferry made decent progress toward the island, but the storm came in faster than anyone expected. The ferry needs to take evasive actions!

Unfortunately, the ship's navigation computer seems to be malfunctioning; rather than giving a route directly to safety, it produced extremely circuitous instructions. When the captain uses the PA system to ask if anyone can help, you quickly volunteer.

The navigation instructions (your puzzle input) consists of a sequence of single-character actions paired with integer input values. After staring at them for a few minutes, you work out what they probably mean:

Action N means to move north by the given value.
Action S means to move south by the given value.
Action E means to move east by the given value.
Action W means to move west by the given value.
Action L means to turn left the given number of degrees.
Action R means to turn right the given number of degrees.
Action F means to move forward by the given value in the direction the ship is currently facing.
The ship starts by facing east. Only the L and R actions change the direction the ship is facing. (That is, if the ship is facing east and the next instruction is N10, the ship would move north 10 units, but would still move east if the following action were F.)

For example:

F10
N3
F7
R90
F11
These instructions would be handled as follows:

F10 would move the ship 10 units east (because the ship starts by facing east) to east 10, north 0.
N3 would move the ship 3 units north to east 10, north 3.
F7 would move the ship another 7 units east (because the ship is still facing east) to east 17, north 3.
R90 would cause the ship to turn right by 90 degrees and face south; it remains at east 17, north 3.
F11 would move the ship 11 units south to east 17, south 8.
At the end of these instructions, the ship's Manhattan distance (sum of the absolute values of its east/west position and its north/south position) from its starting position is 17 + 8 = 25.

Figure out where the navigation instructions lead. What is the Manhattan distance between that location and the ship's starting position?
=end

def wrap_degrees(degrees)
  while degrees <= 0
    degrees += 360
  end

  while degrees > 360
    degrees %= 360
  end
  degrees
end

def compute_new_position_and_orientation(action, offset, position, orientation)
  case action
  when "N" # north
    position[:y] = position[:y] + offset
  when "S" # south
    position[:y] = position[:y] - offset
  when "E" # east
    position[:x] = position[:x] + offset
  when "W" # west
    position[:x] = position[:x] - offset
  when "L" # rotate counterclockwise
    orientation -= offset
    orientation = wrap_degrees(orientation)
  when "R" # rotate clockwise
    orientation += offset
    orientation = wrap_degrees(orientation)
  when "F" # forward
    case orientation
    when 0, 360
      position[:y] = position[:y] + offset
    when 90
      position[:x] = position[:x] + offset
    when 180
      position[:y] = position[:y] - offset
    when 270
      position[:x] = position[:x] - offset
    end
  end
  # p [action, offset, position, orientation]
  [position, orientation]
end


file = File.open("input.txt")
input = file.read.split

ship_position = {x: 0, y: 0}
ship_orientation = 90
input.each do |instruction|
  action = instruction[0]
  offset = instruction[1..-1].to_i

  ship_position, ship_orientation = compute_new_position_and_orientation(
      action, offset, ship_position, ship_orientation
  )
end

p ship_position, ship_orientation

manhattan_distance = ship_position[:x].abs + ship_position[:y].abs
p manhattan_distance
