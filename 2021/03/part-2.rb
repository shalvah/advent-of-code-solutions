input = File.read(File.join(__dir__, "input.txt")).split("\n").map { |line| line.split("").map(&:to_i) }

def find_rating(input, criteria)
  passing_lines = input
  (0...input[0].size).each do |bit_index|
    break if passing_lines.size === 1

    seen_bits = passing_lines.map { |number| number[bit_index] }.tally
    passing_lines = passing_lines.filter do |number|
      number[bit_index] == criteria.call(seen_bits)
    end
  end

  passing_lines.pop
end

most_common_bit = ->(seen_bits) { (seen_bits[1] >= seen_bits[0]) ? 1 : 0 }
least_common_bit = ->(seen_bits) { (seen_bits[0] <= seen_bits[1]) ? 0 : 1 }

oxygen = find_rating(input, most_common_bit)
co2 = find_rating(input, least_common_bit)

p oxygen.join.to_i(2) * co2.join.to_i(2)
