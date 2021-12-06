fish = File.read(File.join(__dir__, "input.txt")).split(",").map(&:to_i)

# Part 1 and 2 really can use the same solution, but I've chosen to stick with
# this "naive" version for Part 1
80.times do
  next_fish_state = []
  fish.each do |timer|
    additions = timer == 0 ? [6, 8] : timer - 1
    next_fish_state.push(*additions)
  end
  fish = next_fish_state
end

p fish.size
