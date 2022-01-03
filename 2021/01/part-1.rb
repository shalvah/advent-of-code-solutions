input = File.read(File.join(__dir__, "input.txt")).split.map(&:to_i)

increased_from_previous = Proc.new { |(prev_value, value)| value > prev_value }

p input.each_cons(2).filter(&increased_from_previous).size