input = File.read(File.join(__dir__, "input.txt")).split("\n")

# Ruby's ~ gives us ones complement, so we reimplement bit flipping
def flip_bit(bit)
  case bit
  when 0
    1
  when 1
    0
  end
end

most_common_bits = []
seen_bits = []
input.each do |line|
  line.split("").each_with_index do |bit, index|
    bit = bit.to_i
    seen_bits[index] = [0, 0] unless seen_bits[index]
    seen_bits[index][bit] += 1
    if seen_bits[index][bit] > seen_bits[index][~bit]
      most_common_bits[index] = bit
    end
  end
end

gamma = most_common_bits.join.to_i(2)
epsilon = most_common_bits.map { |b| flip_bit(b) }.join.to_i(2)

p gamma * epsilon
