input = File.read(File.join(__dir__, "input.txt")).split

greater = 0
input.each_with_index do |measurement, index|
  if index > 0 && Integer(measurement) > Integer(input[index - 1])
    greater += 1
  end
end

p greater