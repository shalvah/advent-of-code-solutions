input = File.read('day_3.txt')

item_to_priority = lambda do |item|
  case item
    in ("a".."z")
      item.ord - 96 # a is 97
    else
      item.ord - 38 # A is 65
  end
end

require 'set'

duplicate_items = input.each_line.flat_map do |rucksack|
  rucksack.chomp.split("").each_slice(rucksack.size/2).map(&Set.method(:new))
    .reduce(&:intersection).to_a
end

# Part 1
p duplicate_items.map(&item_to_priority).sum


common_items = input.split.each_slice(3).flat_map do |rucksacks|
  rucksacks.map { Set.new(_1.split("")) }
    .reduce(&:intersection).to_a
end

# Part 2
p common_items.map(&item_to_priority).sum
