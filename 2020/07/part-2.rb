=begin
--- Part Two ---
It's getting pretty expensive to fly these days - not because of ticket prices, but because of the ridiculous number of bags you need to buy!

Consider again your shiny gold bag and the rules from the above example:

faded blue bags contain 0 other bags.
dotted black bags contain 0 other bags.
vibrant plum bags contain 11 other bags: 5 faded blue bags and 6 dotted black bags.
dark olive bags contain 7 other bags: 3 faded blue bags and 4 dotted black bags.
So, a single shiny gold bag must contain 1 dark olive bag (and the 7 bags within it) plus 2 vibrant plum bags (and the 11 bags within each of those): 1 + 1*7 + 2 + 2*11 = 32 bags!

Of course, the actual rules have a small chance of going several levels deeper than this example; be sure to count all of the bags, even if the nesting becomes topologically impractical!

Here's another example:

shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.
In this example, a single shiny gold bag must contain 126 other bags.

How many individual bags are required inside your single shiny gold bag?
=end

require 'set'

file = File.open("input.txt")
input = file.read.split("\n")

# Process the input into a list of rules
$allowed_children = {}
$allowed_parents = {}
input.each do |line|
  parent, can_contain = line.chomp(".").split(" bags contain ")
  if can_contain == "no other bags"
    $allowed_children[parent] = nil
  else
    children = can_contain.split(", ")
    $allowed_children[parent] = children.map do |child|
      matches = child.scan(/(\d+)\s(.+)\sbags?/)
      number, colour = matches[0]

      # Side effect: add to the reverse tree
      $allowed_parents[colour] ||= Set.new
      $allowed_parents[colour].add parent

      [number.to_i, colour]
    end
  end
end

def bags_inside(colour)
  all_bags_inside = 0
  direct_children = $allowed_children[colour]
  if direct_children
    direct_children.each do |child|
      all_bags_inside += child[0]
      all_bags_inside += child[0] * bags_inside(child[1])
    end
  end

  return all_bags_inside
end

p bags_inside("shiny gold")
