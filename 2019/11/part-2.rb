=begin
--- Part Two ---
You're not sure what it's trying to paint, but it's definitely not a registration identifier. The Space Police are getting impatient.

Checking your external ship cameras again, you notice a white panel marked "emergency hull painting robot starting panel". The rest of the panels are still black, but it looks like the robot was expecting to start on a white panel, not a black one.

Based on the Space Law Space Brochure that the Space Police attached to one of your windows, a valid registration identifier is always eight capital letters. After starting the robot on a single white panel instead, what registration identifier does it paint on your hull?
=end

require 'set'
require './intcode'

def wrap_degrees(degrees)
  while degrees <= 0
    degrees += 360
  end

  while degrees > 360
    degrees %= 360
  end
  degrees
end

file = File.open("input.txt")
input = file.read.split(',')

Black = "0"
White = "1"
Left = "0"
Right = "1"

robot_position = {x: 0, y: 0}
robot_degrees_offset = 0

colours = {}

input_fn = lambda do
  # Starting position is initially white
  if robot_position[:x] == 0 && robot_position[:y] == 0 && colours[robot_position.to_s] === nil
    current_colour = White
  else
    current_colour = colours[robot_position.to_s] || Black
  end

  # p "Input: #{current_colour}"
  current_colour
end

outputs = []
min_x = 0
min_y = 0
hull = {}

output_fn = lambda do |output|
  outputs << output

  if outputs.size == 2
    # This means direction has been provided
    # So paint the current square
    colour_to_paint = outputs.shift
    colours[robot_position.to_s] = colour_to_paint

    (x, y) = robot_position[:x], robot_position[:y]
    if colour_to_paint.to_s == White
      hull[[x,y]] = White
    else
      hull[[x,y]] = Black
    end

    # And calculate the new position
    direction = outputs.pop
    if direction.to_s == Left
      robot_degrees_offset -= 90
      robot_degrees_offset = wrap_degrees(robot_degrees_offset)
    else
      robot_degrees_offset += 90
      robot_degrees_offset = wrap_degrees(robot_degrees_offset)
    end

    case robot_degrees_offset
    when 0, 360
      robot_position[:y] = robot_position[:y] + 1
    when 90
      robot_position[:x] = robot_position[:x] + 1
    when 180
      robot_position[:y] = robot_position[:y] - 1
    when 270
      robot_position[:x] = robot_position[:x] - 1
    end

    min_x = robot_position[:x] if robot_position[:x] < min_x
    min_y = robot_position[:y] if robot_position[:y] < min_y
  end
end

program = Intcode.new(input, input_fn, output_fn)
program.execute

# First, we need to convert our grid, since it uses -ve coordinates, but a Ruby array won'r
deltaX = min_x.abs
deltaY = min_y.abs

# Draw actual grid
grid = []
hull.each do |(x, y), colour|
  x += deltaX
  y += deltaY

  grid[y] ||= []
  grid[y][x] = if colour == Black then "⚫" else "⚪" end
end

grid.each do |x|
  x.each_with_index do |y, i|
    if y == nil
      print "⚫"
    else
      print y
    end
  end
  print "\n"
end

# Answer is upside down 🤣
