herd_map = File.read(File.join(__dir__, "input.txt")).split("\n").map { _1.split("") }

def adjacent_square(x, y, char, map)
  case char
  when ">" # moving to the right
    x_n, y_n = [(x == map[0].size - 1) ? 0 : x + 1, y]
  when "v" # moving down
    x_n, y_n = [x, (y == map.size - 1) ? 0 : y + 1]
  end
end

stopped_at = nil
(1..Float::INFINITY).each do |step|
  initial = herd_map
  next_state = herd_map.map { |row| row.dup }

  # First move the >'s
  herd_map.each.with_index do |row, y|
    row.each.with_index do |char, x|
      if char === ">"
        x_n, y_n = adjacent_square(x, y, char, herd_map)
        if herd_map[y_n][x_n] == "."
          next_state[y_n][x_n] = char
          next_state[y][x] = "."
        end
      end
    end
  end

  herd_map = next_state
  next_state = herd_map.map { |row| row.dup }
  # Then the v's
  herd_map.each.with_index do |row, y|
    row.each.with_index do |char, x|
      if char === "v"
        x_n, y_n = adjacent_square(x, y, char, herd_map)
        if herd_map[y_n][x_n] == "."
          next_state[y_n][x_n] = char
          next_state[y][x] = "."
        end
      end
    end
  end

  herd_map = next_state
  break (stopped_at = step) if initial == herd_map
end

p stopped_at