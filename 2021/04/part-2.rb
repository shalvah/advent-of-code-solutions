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
# The game stops when every board has at least one row or column fully marked (== 5)
marked_columns, marked_rows = [], []
bingo_input = bingo_input.split(',').map(&:to_i)
drawn_numbers = []
winning_states = []
winners = []
until winners.size == boards.size do
  drawn_numbers << (next_number = bingo_input.shift)
  number_appearances[next_number].each do |(board_index, row_index, column_index)|
    marked_rows[board_index] ||= [0] * CELLS_PER_ROW
    marked_columns[board_index] ||= [0] * CELLS_PER_COLUMN
    marked_rows[board_index][row_index] += 1
    marked_columns[board_index][column_index] += 1
    
    if marked_rows[board_index][row_index] == 5 && !winners.include?(board_index)
      winners << board_index
      winning_states[board_index] = [:row, row_index]
    elsif marked_columns[board_index][column_index] == 5 && !winners.include?(board_index)
      winners << board_index
      winning_states[board_index] = [:column, column_index]
    end
  end
end

last_winner = winners.pop
winning_board = case winning_states[last_winner][0]
  when :row
    boards[last_winner]
  when :column
    boards[last_winner].transpose
  end

unmarked_numbers = winning_board.flat_map.with_index do |row_or_col, index|
  index == winning_states[last_winner][1] ? [] : row_or_col - drawn_numbers
end

p unmarked_numbers.sum * drawn_numbers.pop.to_i
