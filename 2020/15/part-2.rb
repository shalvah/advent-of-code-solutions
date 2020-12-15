=begin
--- Part Two ---
Impressed, the Elves issue you a challenge: determine the 30000000th number spoken. For example, given the same starting numbers as above:

Given 0,3,6, the 30000000th number spoken is 175594.
Given 1,3,2, the 30000000th number spoken is 2578.
Given 2,1,3, the 30000000th number spoken is 3544142.
Given 1,2,3, the 30000000th number spoken is 261214.
Given 2,3,1, the 30000000th number spoken is 6895259.
Given 3,2,1, the 30000000th number spoken is 18.
Given 3,1,2, the 30000000th number spoken is 362.
Given your starting numbers, what will be the 30000000th number spoken?
=end

input = [1,17,0,10,18,11,6]

spoken_numbers = {}
current_number = []

# Same solution as Part 1; just change n
n = 30000000
n.times do |i|
  if i < input.size
    current_number = input[i]
  else
    last_number_spoken = current_number
    if spoken_numbers[last_number_spoken] != nil
      last_spoken = spoken_numbers[last_number_spoken].last
      if spoken_numbers[last_number_spoken].size == 1
        current_number = 0
      else
        last_spoken_before_that = spoken_numbers[last_number_spoken][-2]
        current_number = last_spoken - last_spoken_before_that
      end
    end
  end

  spoken_numbers[current_number] ||= []
  spoken_numbers[current_number] << i
end

p current_number

  sequence << number
  spoken_numbers[number] ||= []
  spoken_numbers[number] << i
end

p sequence.last
