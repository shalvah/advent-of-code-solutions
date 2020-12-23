=begin
--- Part Two ---
Due to what you can only assume is a mistranslation (you're not exactly fluent in Crab), you are quite surprised when the crab starts arranging many cups in a circle on your raft - one million (1000000) in total.

Your labeling is still correct for the first few cups; after that, the remaining cups are just numbered in an increasing fashion starting from the number after the highest number in your list and proceeding one by one until one million is reached. (For example, if your labeling were 54321, the cups would be numbered 5, 4, 3, 2, 1, and then start counting up from 6 until one million is reached.) In this way, every number from one through one million is used exactly once.

After discovering where you made the mistake in translating Crab Numbers, you realize the small crab isn't going to do merely 100 moves; the crab is going to do ten million (10000000) moves!

The crab is going to hide your stars - one each - under the two cups that will end up immediately clockwise of cup 1. You can have them if you predict what the labels on those cups will be when the crab is finished.

In the above example (389125467), this would be 934001 and then 159792; multiplying these together produces 149245887792.

Determine which two cups will end up immediately clockwise of cup 1. What do you get if you multiply their labels together?
=end

def remove_next_three(cups, current_cup)
  next_three = []

  original_cup = current_cup

  while next_three.size < 3
    next_cup = cups[current_cup]
    next_three << next_cup
    current_cup = next_cup
  end

  cups[original_cup] = cups[current_cup]
  next_three
end

def get_lower_cup(current_cup, excluded_cups, minimum, maximum)
  lower_cup = current_cup - 1
  if lower_cup < minimum
    lower_cup = maximum
  end

  while excluded_cups.include?(lower_cup)
    lower_cup -= 1

    if lower_cup < minimum
      lower_cup = maximum
    end
  end

  lower_cup
end

def insert_cups(picked_up, destination_cup,cups)
  final = cups[destination_cup]

  cups[destination_cup] = picked_up[0]
  cups[picked_up[2]] = final
end

def next_cups_from_1(cups)
  current_cup = 1
  cups_list = []
  2.times do
    cups_list << cups[current_cup]
    current_cup = cups[current_cup]
  end

  cups_list
end

cups_list = "463528179".split('').map(&:to_i)

cups = []
cups_list.each_with_index do |cup, index|
  cups[cup] = cups_list[index + 1]
end

min = cups_list.min
max = cups_list.max

i = max + 1
while i < 1_000_000
  cups[i] = i + 1
  i += 1
end

cups[cups_list[-1]] = max + 1
cups[1_000_000] = cups_list[0]
max = 1_000_000

current_cup = cups_list[0]

moves = 0
while moves < 10_000_000
  moves += 1
  pick_up = remove_next_three(cups, current_cup)
  destination_cup = get_lower_cup(current_cup, pick_up, min, max)

  insert_cups(pick_up, destination_cup, cups)
  current_cup = cups[current_cup]
  # p [current_cup, cups[current_cup]]
end

p next_cups_from_1(cups).reduce(:*)
