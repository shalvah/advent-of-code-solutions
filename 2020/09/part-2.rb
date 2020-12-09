=begin
--- Part Two ---
The final step in breaking the XMAS encryption relies on the invalid number you just found: you must find a contiguous set of at least two numbers in your list which sum to the invalid number from step 1.

Again consider the above example:

35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
In this list, adding up all of the numbers from 15 through 40 produces the invalid number from step 1, 127. (Of course, the contiguous set of numbers in your actual list might be much longer.)

To find the encryption weakness, add together the smallest and largest number in this contiguous range; in this example, these are 15 and 47, producing 62.

What is the encryption weakness in your XMAS-encrypted list of numbers?
=end

def can_make_number(available_numbers, number)
  available_numbers.each_with_index do |current, index|
    complement = number - current.to_i
    # Search from the other direction
    complement_index = available_numbers.rindex { |m| m.to_i == complement }
    if complement_index != nil && complement_index != index
      return true
    end
  end
  false
end

def find_invalid(numbers, backfill_length)

  i = backfill_length # Skip the preamble
  while i < numbers.size
    n = numbers[i].to_i
    previous = numbers[i - backfill_length, backfill_length]
    if !can_make_number(previous, n)
      return [i, n]
    end
    i += 1
  end
end

def has_contiguous_sum(list, value)
  # Generate all the possible contiguous sums starting from this number
  # Stop if we find one that gives us our value
  list.each_with_index do |n, index|
    min = max = sum = n.to_i
    end_index = index + 1

    while sum <= value && index < list.size
      current_value = list[end_index].to_i

      # Track the smallest and largest numbers we've seen
      max = current_value if current_value > max
      min = current_value if current_value < min

      sum += current_value
      if sum == value
        return {:smallest => min, :largest => max}
      end
      end_index += 1
    end
  end
  return false
end

def find_weakness(invalid_index, invalid_value, numbers)
  i = invalid_index
  while i >= 0
    result = has_contiguous_sum(numbers[0, i], invalid_value)
    if result === false
      next
    else
      return result[:smallest] + result[:largest]
    end
  end
end

file = File.open("input.txt")
input = file.read
numbers = input.split
invalid_index, invalid_value = find_invalid(numbers, 25)
p find_weakness(invalid_index, invalid_value, numbers)
