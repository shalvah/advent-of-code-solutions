input = File.read(File.join(__dir__, "input.txt")).split("\n")
bingo_input = input.shift.split(',')
input.shift
boards = []
number_appearances = {}
input.each_slice(6) do |board_lines|
  board_lines.pop if board_lines.length == 6
  board_lines = board_lines.map(&:split)
  boards << board_lines

  board_index = boards.size - 1
  board_lines.each_with_index do |row, row_index|
    row.each_with_index do |value, col_index|
      number_appearances[value] ||= []
      number_appearances[value] << { board: board_index, row: row_index, column: col_index }
    end
  end
end

winners = []
winning_state = []
marked_rows = []
marked_columns = []
marked_numbers = []
until bingo_input.empty? do
  next_number = bingo_input.shift
  marked_numbers << next_number
  number_appearances[next_number].each do |details|
    board_index = details[:board]

    marked_rows[board_index] ||= (0..4).map { 0 }
    marked_columns[board_index] ||= (0..4).map { 0 }
    marked_rows[board_index][details[:row]] += 1
    marked_columns[board_index][details[:column]] += 1
    if marked_rows[board_index][details[:row]] >= 5 && !winners.include?(board_index)
      winners << board_index
      winning_state[board_index] = [:row, details[:row]]
    elsif marked_columns[board_index][details[:column]] >= 5 && !winners.include?(board_index)
      winners << board_index
      winning_state[board_index] = [:column, details[:column]]
    end
  end

  break if winners.size == boards.size
end

final_winner = winners.pop
unmarked_numbers = []
case winning_state[final_winner][0]
when :row
  boards[final_winner].each_with_index do |row, index|
    next if index == winning_state[final_winner][1]

    new_row = row.filter do |value|
      !marked_numbers.include?(value)
    end
    unmarked_numbers << new_row
  end
when :column
  boards[final_winner].transpose.each_with_index do |column, index|
    next if index == winning_state[final_winner][1]

    new_column = column.filter do |value|
      !marked_numbers.include?(value)
    end
    unmarked_numbers << new_column
  end
end

sum = unmarked_numbers.map { |line| line.map(&:to_i).sum }.sum
p sum * marked_numbers.pop.to_i
