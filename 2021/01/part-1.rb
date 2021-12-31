input = File.read(File.join(__dir__, "input.txt")).split.map(&:to_i)

increased_from_previous = Proc.new { |measurements| measurements[1] > measurements[0] }

p input.each_cons(2).filter(&increased_from_previous).size