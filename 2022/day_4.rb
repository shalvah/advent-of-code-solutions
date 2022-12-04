input = File.read('day_4.txt')

assignments = input.each_line.map do |line|
  line.split(",").map { |pair| pair.split("-").map(&:to_i) }
end

# Part 1
range_contains_other = ->(range, other) { range[0] <= other[0] && range[1] >= other[1] }

p(assignments.filter do |pairs|
  range_contains_other.(pairs[0], pairs[1]) || range_contains_other.(pairs[1], pairs[0])
end.count)


# Part 2
p(assignments.filter do |pairs|
  lower, upper = pairs.sort_by { _1[0] } # Need the pair that starts with the lower number first
  lower[1] >= upper[0]
end.count)
