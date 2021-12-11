$input = File.read(File.join(__dir__, "input.txt")).split("\n").map { |line| line.split("").map(&:to_i) }

def neighbours(x, y)
  below = [x, y + 1] rescue nil
  right = [x + 1, y] rescue nil
  left = [x - 1, y] rescue nil
  above = [x, y - 1] rescue nil
  left_below = [x - 1, y + 1] rescue nil
  left_above = [x - 1, y - 1] rescue nil
  right_below = [x + 1, y + 1] rescue nil
  right_above = [x + 1, y - 1] rescue nil

  [
    (below if y < $input.size - 1),
    (above if y > 0),
    (left if x > 0),
    (right if x < $input[y].size - 1),
    (left_below if x > 0 && y < $input.size - 1),
    (left_above if x > 0 && y > 0),
    (right_below if x < $input[y].size - 1 && y < $input.size - 1),
    (right_above if x < $input[y].size - 1 && y > 0),
  ].compact
end

energy_levels = $input

require 'set'

step = 0
synced = false
until synced do
  step += 1
  next_state = energy_levels.map(&:dup)
  flashed = Set.new

  # Part A and B: increase levels by 1, and flash
  energy_levels.each_with_index do |line, y|
    line.each_with_index do |octopus, x|
      next_state[y][x] += 1
      if octopus > 9 && !flashed.include?([x, y])
        flashed << [x, y]
        # Increment for neighbours
        neighbours(x, y).each { |(x_n, y_n)| next_state[y_n][x_n] += 1 }
      end
    end
  end

  # Keep flashing, until there's no more left to flash🤪
  found_9 = true
  while found_9
    found_9 = false
    next_state.each_with_index do |line, y|
      line.each_with_index do |octopus, x|
        if octopus > 9 && !flashed.include?([x, y])
          found_9 = true
          flashed << [x, y]
          # Increment for neighbours
          neighbours(x, y).each { |(x_n, y_n)| next_state[y_n][x_n] += 1 }
        end
      end
    end
  end

  # Check answer, or do Part C: reset all flashed to 0
  if flashed.size === (energy_levels.size * energy_levels[0].size)
    synced = true
  else
    flashed.each { |(x, y)| next_state[y][x] = 0 }
  end

  energy_levels = next_state
  flashed
end

p step