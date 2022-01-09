input = File.read(File.join(__dir__, "input.txt")).split("\n")

require_relative './models'

snailfish_numbers = input.map { SnailfishNumber.parse(eval(_1)) }

# Don't you just love Ruby? nCr inbuilt!
sums = snailfish_numbers.combination(2).flat_map do |number_1, number_2|
  [SnailfishNumber.sum(number_1, number_2).magnitude, SnailfishNumber.sum(number_2, number_1).magnitude]
end

p sums.max