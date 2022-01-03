fish_states = File.read(File.join(__dir__, "input.txt")).split(",").map(&:to_i)

# Part 1 and 2 really can use the same solution, but I've chosen to stick with
# this naive version for Part 1
80.times do
  fish_states = fish_states.flat_map do |timer|
    # If the fish is on 0, it will warp over to 6 and add a new 8 fish
    # Otherwise it just decrements
    timer == 0 ? [6, 8] : timer - 1
  end
end

p fish_states.size
