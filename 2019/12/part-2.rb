=begin
--- Part Two ---
All this drifting around in space makes you wonder about the nature of the universe. Does history really repeat itself? You're curious whether the moons will ever return to a previous state.

Determine the number of steps that must occur before all of the moons' positions and velocities exactly match a previous point in time.

For example, the first example above takes 2772 steps before they exactly match a previous point in time; it eventually returns to the initial state:

After 0 steps:
pos=<x= -1, y=  0, z=  2>, vel=<x=  0, y=  0, z=  0>
pos=<x=  2, y=-10, z= -7>, vel=<x=  0, y=  0, z=  0>
pos=<x=  4, y= -8, z=  8>, vel=<x=  0, y=  0, z=  0>
pos=<x=  3, y=  5, z= -1>, vel=<x=  0, y=  0, z=  0>

After 2770 steps:
pos=<x=  2, y= -1, z=  1>, vel=<x= -3, y=  2, z=  2>
pos=<x=  3, y= -7, z= -4>, vel=<x=  2, y= -5, z= -6>
pos=<x=  1, y= -7, z=  5>, vel=<x=  0, y= -3, z=  6>
pos=<x=  2, y=  2, z=  0>, vel=<x=  1, y=  6, z= -2>

After 2771 steps:
pos=<x= -1, y=  0, z=  2>, vel=<x= -3, y=  1, z=  1>
pos=<x=  2, y=-10, z= -7>, vel=<x= -1, y= -3, z= -3>
pos=<x=  4, y= -8, z=  8>, vel=<x=  3, y= -1, z=  3>
pos=<x=  3, y=  5, z= -1>, vel=<x=  1, y=  3, z= -1>

After 2772 steps:
pos=<x= -1, y=  0, z=  2>, vel=<x=  0, y=  0, z=  0>
pos=<x=  2, y=-10, z= -7>, vel=<x=  0, y=  0, z=  0>
pos=<x=  4, y= -8, z=  8>, vel=<x=  0, y=  0, z=  0>
pos=<x=  3, y=  5, z= -1>, vel=<x=  0, y=  0, z=  0>
Of course, the universe might last for a very long time before repeating. Here's a copy of the second example from above:

<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
This set of initial positions takes 4686774924 steps before it repeats a previous state! Clearly, you might need to find a more efficient way to simulate the universe.

How many steps does it take to reach the first state that exactly matches a previous state?
=end

file = File.open("input.txt")
input = file.read.split("\n")

Dimensions = [:x, :y, :z]

moons = input.map do |data|
  match = data.match(/<x=(?<x>.+), y=(?<y>.+), z=(?<z>.+)>/)
  {
      position: {
          x: match[:x].to_i,
          y: match[:y].to_i,
          z: match[:z].to_i
      },
      velocity: {x: 0, y: 0, z: 0}
  }
end

def find(moons)
  # Calculate cycle for each dimension separately, since dimension values are independent
  steps = {x: 0, y: 0, z: 0}
  Dimensions.each do |dimension|
    initial_positions = moons.map { |moon| moon[:position][dimension] }
    initial_velocities = moons.map { |moon| moon[:velocity][dimension] }

    loop do
      current_positions = []
      current_velocities = []

      moons.each_with_index do |current_moon, index|
        moons.each_with_index do |other_moon, i|
          next if index == i

          # Apply gravity
          if current_moon[:position][dimension] > other_moon[:position][dimension]
            current_moon[:velocity][dimension] -= 1
          elsif current_moon[:position][dimension] < other_moon[:position][dimension]
            current_moon[:velocity][dimension] += 1
          end
        end
      end

      # Apply velocities
      moons.each_with_index do |current_moon, index|
        current_moon[:position][dimension] += current_moon[:velocity][dimension]
        current_positions[index] = current_moon[:position][dimension]
        current_velocities[index] = current_moon[:velocity][dimension]
      end

      steps[dimension] += 1
      break if (initial_positions == current_positions) && (initial_velocities == current_velocities)
    end
  end
  steps
end


cycles = find(moons)
# Look for the first place all cycles converge
min_steps = cycles.values.reduce(&:lcm)
p min_steps
