risk_levels = File.read(File.join(__dir__, "input.txt")).split("\n").map { |line| line.split("").map(&:to_i) }

def wrap(value)
  while value > 9
    value = (value % 10) + (value / 10).to_i
  end
  value
end

# Expand the map
expanded = []
risk_levels.each_with_index do |line, line_index|
  new_line = []
  line.each_with_index do |value, index|
    5.times do |i|
      new_line[index + (i * line.size)] = wrap(value + i)
    end
  end
  5.times do |i|
    extra_line = new_line.map { |value| wrap(value + i) }
    expanded[line_index + (i * risk_levels.size)] = extra_line
  end
end

risk_levels = expanded

# Rest of solution same as Part 1...

def get_neighbours(risk_levels, x, y, all = false)
  [
    ([x, y + 1] if y < risk_levels.size - 1),
    ([x + 1, y] if x < risk_levels[0].size - 1),
    ([x - 1, y] if all && x > 0),
    ([x, y - 1] if all && y > 0),
  ].compact
end

end_point = [risk_levels[0].size - 1, risk_levels.size - 1]

minimal_risk_levels = {}

# Stage 1: calculate the minimum for each point to the bottom
# At this point, we will only have rightward and downward neighbours, so this is incomplete
y = risk_levels.size - 1
until y < 0 do
  x = risk_levels[0].size - 1 # Start with the rightmost point
  minimal_risk_levels[y] = []

  until x < 0 do
    if [x, y] == end_point
      minimal_risk_levels[y][x] = risk_levels[y][x]
      x -= 1
      next
    end

    neighbours = get_neighbours(risk_levels, x, y)
    minimal_risk = neighbours.map { |(x_n, y_n)| minimal_risk_levels[y_n][x_n] }.min
    minimal_risk_levels[y][x] = minimal_risk + risk_levels[y][x]
    x -= 1
  end

  y -= 1
end

# Now we have minimal cost for each point, if we're only going up and left (from destination)
# Let's recalculate, including *all* neighbours this time
previous = minimal_risk_levels[0][0] - risk_levels[0][0]
latest = nil
until previous == latest do
  y = risk_levels.size - 1
  until y < 0 do
    x = risk_levels[0].size - 1
    until x < 0 do
      next (x -= 1) if [x, y] == end_point

      neighbours = get_neighbours(risk_levels, x, y, true)
      minimal_risk = neighbours.map { |(x_n, y_n)| minimal_risk_levels[y_n][x_n] }.min
      minimal_risk_levels[y][x] = minimal_risk + risk_levels[y][x]
      x -= 1
    end

    y -= 1
  end

  previous = latest
  latest = minimal_risk_levels[0][0] - risk_levels[0][0]
end

p latest