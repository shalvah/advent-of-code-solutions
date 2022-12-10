instructions = File.readlines('day_10.txt').map { |line| line.split(' ') }

x_values = [1]
instructions.each do |(instr, arg)|
  prev = x_values.last
  case instr
    when 'noop'; x_values << prev
    when 'addx'; x_values.push(prev, prev + arg.to_i)
  end
end

# Part 1
p [x_values[19] * 20, x_values[59] * 60, x_values[99] * 100, x_values[139] * 140, x_values[179] * 180, x_values[219] * 220].sum


# Part 2
drawn = 6.times.map { [] }

visualize = ->(cycle, index, current_x_position, row) do
  puts "Start of cycle #{cycle + 1}: cpu is at #{index}, X is at #{current_x_position}"
  puts "CPU draws: #{row.join}\n"
end

drawn.each_with_index do |row, row_index|
  40.times.each do |index|
    cycle = (row_index * 40) + index
    current_x_position = x_values[cycle]
    if (current_x_position - index == 1) || (current_x_position - index == -1) || (current_x_position - index == 0)
      row << '#'
    else
      row << '.'
    end
    # Debugging:
    # visualize.(cycle, index, current_x_position, row) if cycle < 20
  end
end


puts "\n"
drawn.each { |row| puts row.map { _1 == '.' ? ' ' : _1 }.join(' ') } # Easier to read if we replace '.'s with spaces
