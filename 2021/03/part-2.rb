input = File.read(File.join(__dir__, "input.txt")).split("\n")

number_of_bits = input[0].size

lines_oxygen = input
(0...number_of_bits).each do |bit_index|
  seen_bits_oxygen = [0, 0]

  break if lines_oxygen.size === 1

  (0...lines_oxygen.size).each do |line_index|
    current_bit = lines_oxygen[line_index][bit_index].to_i
    seen_bits_oxygen[current_bit] += 1
  end

  lines_oxygen = lines_oxygen.filter do |line|
    current_bit = line[bit_index].to_i
    current_bit == ((seen_bits_oxygen[1] >= seen_bits_oxygen[0]) ? 1 : 0)
  end
end

lines_co2 = input
(0...number_of_bits).each do |bit_index|
  seen_bits_co2 = [0, 0]

  break if lines_co2.size === 1

  (0...lines_co2.size).each do |line_index|
    current_bit = lines_co2[line_index][bit_index].to_i
    seen_bits_co2[current_bit] += 1
  end

  lines_co2 = lines_co2.filter do |line|
    current_bit = line[bit_index].to_i
    current_bit == ((seen_bits_co2[0] <= seen_bits_co2[1]) ? 0 : 1)
  end
end

co2 = lines_co2.pop
oxygen = lines_oxygen.pop

p oxygen.to_i(2) * co2.to_i(2)
