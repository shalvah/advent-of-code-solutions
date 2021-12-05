bingo_input, *input = File.read(File.join(__dir__, "input.txt")).split("\n").reject(&:empty?)

boards = []
number_appearances = {}
input.each_slice(5) do |board_lines|
  boards << board_lines.map!(&:split)

  board_index = boards.size - 1
  board_lines.each_with_index do |row, row_index|
    row.each_with_index do |value, col_index|
      number_appearances[value] ||= []
      number_appearances[value] << [board_index, row_index, col_index]
    end
  end
end

winning_board_index, winning_state = nil, nil
marked_numbers = []
marked_columns, marked_rows = [], []
bingo_input = bingo_input.split(',')
until winning_board_index != nil do
  marked_numbers << (next_number = bingo_input.shift)

  number_appearances[next_number].each do |(board_index, row_index, column_index)|
    marked_rows[board_index] ||= (0..4).map { 0 }
    marked_columns[board_index] ||= (0..4).map { 0 }
    marked_rows[board_index][row_index] += 1
    marked_columns[board_index][column_index] += 1

    if marked_rows[board_index][row_index] >= 5
      winning_board_index = board_index
      winning_state = [:row, row_index]
    elsif marked_columns[board_index][column_index] >= 5
      winning_board_index = board_index
      winning_state = [:column, column_index]
    end
  end
end

unmarked_numbers = []
board = case winning_state[0]
  when :row
    boards[winning_board_index]
  when :column
    boards[winning_board_index].transpose
  end

board.each_with_index do |row_or_col, index|
  next if index == winning_state[1]
  unmarked_numbers << row_or_col - marked_numbers
end

sum = unmarked_numbers.map { |line| line.map(&:to_i).sum }.sum
p sum * marked_numbers.pop.to_i
