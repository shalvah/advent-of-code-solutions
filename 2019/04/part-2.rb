=begin
--- Part Two ---
An Elf just remembered one more important detail: the two adjacent matching digits are not part of a larger group of matching digits.

Given this additional criterion, but still ignoring the range rule, the following are now true:

112233 meets these criteria because the digits never decrease and all repeated digits are exactly two digits long.
123444 no longer meets the criteria (the repeated 44 is part of a larger group of 444).
111122 meets the criteria (even though 1 is repeated more than twice, it still contains a double 22).
How many different passwords within the range given in your puzzle input meet all of the criteria?

Your puzzle input is still 125730-579381.
=end

lo = 125730
hi = 579381

valid_passwords = []

(lo..hi).each do |val|
    has_repeating = false
    num_as_str = val.to_s
    has_no_decreasing = num_as_str.each_char.with_index  do |char, index|
        break false if index > 0 && char.to_i < num_as_str[index - 1].to_i # Fail if there's a decreasing digit
        
        if char == num_as_str[index + 1] && # If next character is same as this one
            char != num_as_str[index - 1] && # But not same as the one before this,
            char != num_as_str[index + 2] # And not same as the one after next
        then
            has_repeating = true
        end
    end

    valid_passwords << val if has_repeating && has_no_decreasing
end

print valid_passwords.size
