input = File.read(File.join(__dir__, "input.txt")).split

greater = 0
prev_sum = Float::INFINITY

input.each_with_index do |measurement, index|
  next if index < 2

  sum = Integer(measurement) + Integer(input[index - 1]) + Integer(input[index - 2])
  if sum > prev_sum
    greater += 1
  end
  prev_sum = sum
end

p greater