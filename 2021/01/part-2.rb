input = File.read(File.join(__dir__, "input.txt")).split.map(&:to_i)

increased_from_previous = Proc.new { |(prev_sum, sum)| sum > prev_sum }

sliding_window_sums = input.each_cons(3).map(&:sum)
p sliding_window_sums.each_cons(2).filter(&increased_from_previous).size