input = File.read(File.join(__dir__, "input.txt")).split("\n")

require_relative './models'

snailfish_numbers = input.map do |line|
  array = eval line
  SnailfishNumber.parse(array)
end

sum = SnailfishNumber.sum(*snailfish_numbers)

p sum.magnitude


# SnailfishNumber.parse([[[[[9, 8], 1], 2], 3], 4]).reduce
# SnailfishNumber.parse([7, [6, [5, [4, [3, 2]]]]]).reduce
# SnailfishNumber.parse([[6, [5, [4, [3, 2]]]], 1]).reduce
# SnailfishNumber.parse([[3, [2, [1, [7, 3]]]], [6, [5, [4, [3, 2]]]]]).reduce
# SnailfishNumber.parse([[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]]).reduce
# SnailfishNumber.parse([[[[0,7],4],[15,[0,13]]],[1,1]]).reduce
# SnailfishNumber.parse([[[[[4, 3], 4], 4], [7, [[8, 4], 9]]], [1, 1]]).reduce
