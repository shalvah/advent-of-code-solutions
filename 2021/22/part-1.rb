instructions = File.read(File.join(__dir__, "input.txt")).split("\n").map do |line|
  parsed, _ = line.scan /(\w+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/
  [parsed[0], parsed[1..2].map(&:to_i), parsed[3..4].map(&:to_i), parsed[5..6].map(&:to_i)]
end

require 'set'
on_cubes = Set.new
instructions.each do |(command, x, y, z)|
  # Figure out all the cubes affected by this instruction
  cubes = [-50, x[0]].max.upto([x[1], 50].min).map do |x_n|
    [-50, y[0]].max.upto([y[1], 50].min).map do |y_n|
      [-50, z[0]].max.upto([z[1], 50].min).map do |z_n|
        [x_n, y_n, z_n]
      end
    end.flatten(1)
  end.flatten(1)

  # Then apply the instruction
  if command == "on"
    cubes.map { |c| on_cubes.add c }
  else
    cubes.map { |c| on_cubes.delete c }
  end
end

p on_cubes.size