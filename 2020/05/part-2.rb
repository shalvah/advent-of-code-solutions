=begin
--- Part Two ---
Ding! The "fasten seat belt" signs have turned on. Time to find your seat.

It's a completely full flight, so your seat should be the only missing boarding pass in your list. However, there's a catch: some of the seats at the very front and back of the plane don't exist on this aircraft, so they'll be missing from your list as well.

Your seat wasn't at the very front or back, though; the seats with IDs +1 and -1 from yours will be in your list.

What is the ID of your seat?
=end

require 'set'

def compute_seat(pass)
    available_rows = [0, 127]
    available_columns = [0, 7]
  i = 0
  while i < pass.length
    instruction = pass[i]
    if i <= 6
        available_rows = compute_row(instruction, available_rows)
    else
        available_columns = compute_column(instruction, available_columns)
    end
    i+= 1
  end
  [available_rows[0], available_columns[0]]
end

def compute_row(instruction, rows)
    half = (rows[1] - rows[0] + 1) / 2
    case instruction
    when 'F' # lower half
        [rows[0], rows[1] - half]
    when 'B' # upper half
        [rows[0] + half, rows[1]]
    end
end

def compute_column(instruction, column)
    half = (column[1] - column[0] + 1) / 2
    case instruction
    when 'L' # lower half
        [column[0], column[1] - half]
    when 'R' # upper half
        [column[0] + half, column[1]]
    end
end


file = File.open("input.txt")
boarding_passes = file.read.split

min_seat_id = 0
max_seat_id = (127 * 8) + 7
remaining_seat_ids = (min_seat_id..max_seat_id).to_set # The seat IDs form an AP with step 1

boarding_passes.each do |pass|
row, column = compute_seat(pass)
seat_id = (row * 8) + column
remaining_seat_ids.delete seat_id
end

remaining_seat_ids.select! do |val|
    !remaining_seat_ids.include?(val + 1) && !remaining_seat_ids.include?(val - 1)
end
p remaining_seat_ids.to_a[0]
