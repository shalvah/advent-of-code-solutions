=begin
--- Part Two ---
Now that you've identified which tickets contain invalid values, discard those tickets entirely. Use the remaining valid tickets to determine which field is which.

Using the valid ranges for each field, determine what order the fields appear on the tickets. The order is consistent between all tickets: if seat is the third field, it is the third field on every ticket, including your ticket.

For example, suppose you have the following notes:

class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
Based on the nearby tickets in the above example, the first position must be row, the second position must be class, and the third position must be seat; you can conclude that in your ticket, class is 12, row is 11, and seat is 13.

Once you work out which field is which, look for the six fields on your ticket that start with the word departure. What do you get if you multiply those six values together?
=end

require 'set'

field_values_by_index = []
all_possible_numbers = {}
fields_and_allowed_values = {}
my_ticket = nil

input_mode = "fields"
File.foreach('input.txt') do |line|
  line = line.chomp
  case line
  when "your ticket:"
    input_mode = "your_ticket"
    next
  when "nearby tickets:"
    input_mode = "nearby_tickets"
    next
  when ""
    next
  else
    case input_mode
    when "fields"
      match = line.match(/(?<field>.+): (?<ranges>.+)/)
      ranges = match[:ranges].split(" or")
      ranges.each do |range|
        min, max = range.strip.split("-")
        (min..max).each do |value|
          all_possible_numbers[value] ||= []
          all_possible_numbers[value] << match[:field]
          fields_and_allowed_values[match[:field]] ||= Set.new
          fields_and_allowed_values[match[:field]] << value
        end
      end
    when "your_ticket"
      my_ticket = line.split(',')
    when "nearby_tickets"
      field_values = line.split(',')
      valid = true
      # Get rid of invalid tickets
      field_values.each do |number|
        if all_possible_numbers[number] == nil
          valid = false
          break
        end
      end
      next if !valid

      # Record all values present for each field according to position
      field_values.each_with_index do |number, position|
        field_values_by_index[position] ||= []
        field_values_by_index[position] << number
      end
    end
  end
end

possible_fields = {}

# Go through all fields by position and calculate the possible field names for them
field_values_by_index.each_with_index do |value, index|
  set = value.to_set

  fields_and_allowed_values.each do |field_name, allowed|
    # If all the ticket values for this unknown field fall in the range for this field
    if set.subset?(allowed)
      # then it might be this field
      possible_fields[field_name] ||= []
      possible_fields[field_name] << index
    end
  end
end

# Now we figure out the fields.
solved_ticket = {}
# Start with those with only one option
while possible_fields.size > 0
  known_fields = possible_fields.select { |field, positions| positions.size == 1 }
  known_fields.each do |field, (index, _)|
    solved_ticket[field] = my_ticket[index]
    possible_fields.delete(field)
    ## That index has been solved, remove it from consideration
    possible_fields.each do |field, positions|
      positions.delete(index)
    end
    # And then we go again to those who now have only one option
  end
end


product = 1
solved_ticket.each do |field, value|
  if field.match(/^departure/)
    product *= value.to_i
  end
end

p product
