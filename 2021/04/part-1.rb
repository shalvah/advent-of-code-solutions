bingo_input, *boards = File.read(File.join(__dir__, "input.txt")).split("\n").reject(&:empty?)
CELLS_PER_ROW = CELLS_PER_COLUMN = 5
boards = boards.each_slice(CELLS_PER_COLUMN).map { |board_lines| board_lines.map { |line| line.split.map(&:to_i) } }

number_appearances = {}
boards.each_with_index do |board, board_index|
  board.each_with_index do |row, row_index|
    row.each_with_index do |value, col_index|
      number_appearances[value] ||= []
      number_appearances[value] << [board_index, row_index, col_index]
    end
  end
end

# For each row and column in each board, record how many numbers have been marked
# The game stops when any row or column is fully marked (== 5)
marked_columns, marked_rows = [], []
bingo_input = bingo_input.split(',').map(&:to_i)
drawn_numbers = []
winning_state = nil
until winning_state != nil do
  drawn_numbers << (next_number = bingo_input.shift)

  number_appearances[next_number].each do |(board_index, row_index, column_index)|
    marked_rows[board_index] ||= [0] * CELLS_PER_ROW
    marked_columns[board_index] ||= [0] * CELLS_PER_COLUMN
    marked_rows[board_index][row_index] += 1
    marked_columns[board_index][column_index] += 1

    if marked_rows[board_index][row_index] == 5
      winning_state = {board: board_index, type: :row, type_index: row_index}
    elsif marked_columns[board_index][column_index] == 5
      winning_state = {board: board_index, type: :column, type_index: column_index}
    end
  end
end

unmarked_numbers = []
winning_board = case winning_state[:type]
  when :row
    boards[winning_state[:board]]
  when :column
    boards[winning_state[:board]].transpose
  end

unmarked_numbers = winning_board.flat_map.with_index do |row_or_col, index|
  index == winning_state[:type_index] ? [] : row_or_col - drawn_numbers
end

p unmarked_numbers.sum * drawn_numbers.pop.to_i
