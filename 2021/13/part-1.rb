require 'set'
dots, instructions = File.read(File.join(__dir__, "input.txt")).split("\n\n")
dots = Set.new(dots.split("\n").map { |line| line.split(",").map(&:to_i) })
instructions = instructions.split("\n").map { |line| line.split.at(2).split("=") }

def reflect_point_in_line(line)
  coordinate, value = [line[0], line[1].to_i]

  Proc.new do |(x, y)|
      if coordinate == "y"
        [x, y < value ? y : value - (y - value)]
      else
        [x < value ? x : value - (x - value), y]
      end
    end
end

folded = Set.new(dots.map(&reflect_point_in_line(instructions[0])))

p folded.size