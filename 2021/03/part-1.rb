input = File.read(File.join(__dir__, "input.txt")).split("\n").map { |line| line.split("").map(&:to_i) }

# Ruby's ~ gives us ones complement, so we reimplement bit flipping
def flip_bit(bit)
  case bit
  when 0
    1
  when 1
    0
  end
end

seen_bits_at_each_index = input.transpose.map(&:tally)
most_common_bits = seen_bits_at_each_index.map do |count|
  count[0] > count[1] ? 0 : 1
end
gamma = most_common_bits.join.to_i(2)
epsilon = most_common_bits.map(&method(:flip_bit)).join.to_i(2)

p gamma * epsilon
