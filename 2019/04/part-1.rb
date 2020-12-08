=begin
--- Day 4: Secure Container ---
You arrive at the Venus fuel depot only to discover it's protected by a password. The Elves had written the password on a sticky note, but someone threw it out.

However, they do remember a few key facts about the password:

It is a six-digit number.
The value is within the range given in your puzzle input.
Two adjacent digits are the same (like 22 in 122345).
Going from left to right, the digits never decrease; they only ever increase or stay the same (like 111123 or 135679).
Other than the range rule, the following are true:

111111 meets these criteria (double 11, never decreases).
223450 does not meet these criteria (decreasing pair of digits 50).
123789 does not meet these criteria (no double).
How many different passwords within the range given in your puzzle input meet these criteria?

Your puzzle input is 125730-579381.
=end

lo = 125730
hi = 579381

valid_passwords = []

(lo..hi).each do |val|
    has_adjacent = false
    num_as_str = val.to_s
    has_no_decreasing = num_as_str.each_char.with_index  do |char, index|
        break false if index > 0 && char.to_i < num_as_str[index - 1].to_i # Fail if there's a decreasing digit
        
        has_adjacent = true if index > 0 && char == num_as_str[index - 1] # Pass if adjacent digits
    end

    valid_passwords << val if has_adjacent && has_no_decreasing
end

print valid_passwords.size

# Alternate solution: try to generate the valid numbers instead?🤔
