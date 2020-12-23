=begin
--- Part Two ---
Due to what you can only assume is a mistranslation (you're not exactly fluent in Crab), you are quite surprised when the crab starts arranging many cups in a circle on your raft - one million (1000000) in total.

Your labeling is still correct for the first few cups; after that, the remaining cups are just numbered in an increasing fashion starting from the number after the highest number in your list and proceeding one by one until one million is reached. (For example, if your labeling were 54321, the cups would be numbered 5, 4, 3, 2, 1, and then start counting up from 6 until one million is reached.) In this way, every number from one through one million is used exactly once.

After discovering where you made the mistake in translating Crab Numbers, you realize the small crab isn't going to do merely 100 moves; the crab is going to do ten million (10000000) moves!

The crab is going to hide your stars - one each - under the two cups that will end up immediately clockwise of cup 1. You can have them if you predict what the labels on those cups will be when the crab is finished.

In the above example (389125467), this would be 934001 and then 159792; multiplying these together produces 149245887792.

Determine which two cups will end up immediately clockwise of cup 1. What do you get if you multiply their labels together?
=end

def remove_next_three(cups, next_cup_keys, current_cup_key)
  next_three = []

  original_cup_key = current_cup_key

  while next_three.size < 3
    next_cup_key = next_cup_keys[current_cup_key]
    next_three << cups[next_cup_key]
    current_cup_key = next_cup_key
  end

  next_cup_keys[original_cup_key] = next_cup_keys[current_cup_key]
  next_cup_keys[current_cup_key] = nil
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

def insert_cups(picked_up, destination_index, next_cup_keys, cups_to_keys)
  final = next_cup_keys[destination_index]
  key = destination_index

  cup = picked_up[0]
  cup_key = cups_to_keys[cup]
  next_cup_keys[key] = cup_key
  key = cup_key

  cup = picked_up[1]
  cup_key = cups_to_keys[cup]
  next_cup_keys[key] = cup_key
  key = cup_key

  cup = picked_up[2]
  cup_key = cups_to_keys[cup]
  next_cup_keys[key] = cup_key

  next_cup_keys[cup_key] = final
end

def generate_cups_list(cups, next_cup_keys, cups_to_keys)
  start_at = cups_to_keys[1]
  cups_list = []
  current_key = next_cup_keys[start_at]
  2.times do
    cups_list << cups[current_key]
    current_key = next_cup_keys[current_key]
  end

  cups_list
end

cups_list = "389125467".split('').map(&:to_i)
next_cup_keys = {}
cups_to_keys = {}
cups_list.each_with_index do |cup, index|
  next_cup_keys[index] = index + 1
  cups_to_keys[cup] = index
end

min = cups_list.min
max = cups_list.max

i = max + 1
while i <= 1_000_000
  next_cup_keys[cups_list.size - 1] = cups_list.size
  cups_to_keys[i] = cups_list.size
  cups_list << i
  i += 1
end

next_cup_keys[cups_list.size - 1] = 0

cups = {}
cups_list.each_with_index do |cup, index|
  cups[index] = cup
end

current_cup_key = 0

moves = 0
while moves < 10_000_000
  moves += 1
  pick_up = remove_next_three(cups, next_cup_keys, current_cup_key)
  destination_cup = get_lower_cup(cups[current_cup_key], pick_up, min, max)
  destination_index = cups_to_keys[destination_cup]
  insert_cups(pick_up, destination_index, next_cup_keys, cups_to_keys)
  current_cup_key = next_cup_keys[current_cup_key]
end

p position_of_cup_1 = cups_to_keys[1]
p next_cup_key = next_cup_keys[position_of_cup_1]
p next_cup = cups[next_cup_key]
p next_cup_2 = cups[next_cup_keys[next_cup_key]]
p next_cup * next_cup_2
p generate_cups_list(cups, next_cup_keys, cups_to_keys)
