target_area = File.read(File.join(__dir__, "input.txt")).
  scan(/x=(.+), y=(.+)/)[0].map { |range| range.split("..").map(&:to_i) }

$x_range, $y_range = target_area

matching_x = []
# The x point has to be such that x + (x -1) + (x -2)...+ 0 falls within the x range
# (Assuming the initial x-velocity is positive)
$x_range[1].downto(0) do |x|
  x_position = 0
  x.downto(0) do |x_n|
    x_position += x_n
    break if x_position > $x_range[1]

    if x_position >= $x_range[0] && x_position <= $x_range[1]
      matching_x << x
      break
    end
  end
end

def get_next_position_and_velocity(current_position, velocity)
  new_position = current_position[0] + velocity[0], current_position[1] + velocity[1]
  new_velocity = [velocity[0], velocity[1] - 1]
  if velocity[0] > 0
    new_velocity[0] = velocity[0] - 1
  elsif velocity[0] < 0
    new_velocity[0] = velocity[0] + 1
  end
  [new_position, new_velocity]
end

def in_target_area(x, y)
  x >= $x_range[0] && x <= $x_range[1] &&
    y >= $y_range[0] && y <= $y_range[1]
end

def beyond_target_area(x, y)
  x > $x_range[1] || y < $y_range[0]
end

try_x = matching_x.min

# Brute force
winning_positions = []
upper_y_bound = ($y_range[1] - $y_range[0]).abs * 10 # Guesstimate, but it works 🤣
(0..upper_y_bound).each do |y|
  v = [try_x, y]
  pos = [0, 0]
  positions = []
  definitely_beyond = false
  loop do
    pos, v = get_next_position_and_velocity(pos, v)
    positions << pos[1]
    if beyond_target_area(*pos)
      definitely_beyond = true if pos[0] > $x_range[1]
      break
    elsif in_target_area(*pos)
      winning_positions << positions.max
      break
    end
  end

  break if definitely_beyond
end

p winning_positions.max
