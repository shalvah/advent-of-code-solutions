positions = File.read(File.join(__dir__, "input.txt")).split(",").map(&:to_i)

tallied = positions.tally
sorted = positions.sort

# The best alignment will be at the median
alignment = (sorted[(sorted.size - 1) / 2] + sorted[sorted.size / 2]) / 2

fuel = 0
tallied.each do |pos, freq|
  fuel += (pos - alignment).abs * freq
end

p fuel


