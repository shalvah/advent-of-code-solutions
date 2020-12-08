=begin
ccccc--- Day 5: Binary Boarding ---
You board your plane only to discover a new problem: you dropped your boarding pass! You aren't sure which seat is yours, and all of the flight attendants are busy with the flood of people that suddenly made it through passport control.

You write a quick program to use your phone's camera to scan all of the nearby boarding passes (your puzzle input); perhaps you can find your seat through process of elimination.

Instead of zones or groups, this airline uses binary space partitioning to seat people. A seat might be specified like FBFBBFFRLR, where F means "front", B means "back", L means "left", and R means "right".

The first 7 characters will either be F or B; these specify exactly one of the 128 rows on the plane (numbered 0 through 127). Each letter tells you which half of a region the given seat is in. Start with the whole list of rows; the first letter indicates whether the seat is in the front (0 through 63) or the back (64 through 127). The next letter indicates which half of that region the seat is in, and so on until you're left with exactly one row.

For example, consider just the first seven characters of FBFBBFFRLR:

Start by considering the whole range, rows 0 through 127.
F means to take the lower half, keeping rows 0 through 63.
B means to take the upper half, keeping rows 32 through 63.
F means to take the lower half, keeping rows 32 through 47.
B means to take the upper half, keeping rows 40 through 47.
B keeps rows 44 through 47.
F keeps rows 44 through 45.
The final F keeps the lower of the two, row 44.
The last three characters will be either L or R; these specify exactly one of the 8 columns of seats on the plane (numbered 0 through 7). The same process as above proceeds again, this time with only three steps. L means to keep the lower half, while R means to keep the upper half.

For example, consider just the last 3 characters of FBFBBFFRLR:

Start by considering the whole range, columns 0 through 7.
R means to take the upper half, keeping columns 4 through 7.
L means to take the lower half, keeping columns 4 through 5.
The final R keeps the upper of the two, column 5.
So, decoding FBFBBFFRLR reveals that it is the seat at row 44, column 5.

Every seat also has a unique seat ID: multiply the row by 8, then add the column. In this example, the seat has ID 44 * 8 + 5 = 357.

Here are some other boarding passes:

BFFFBBFRRR: row 70, column 7, seat ID 567.
FFFBBBFRRR: row 14, column 7, seat ID 119.
BBFFBBFRLL: row 102, column 4, seat ID 820.
As a sanity check, look through your list of boarding passes. What is the highest seat ID on a boarding pass?
=end

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
max_id = 0

boarding_passes.each do |pass|
row, column = compute_seat(pass)
seat_id = (row * 8) + column
max_id = seat_id if seat_id > max_id
end

p max_id
