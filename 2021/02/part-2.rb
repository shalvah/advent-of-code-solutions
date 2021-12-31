input = File.read(File.join(__dir__, "input.txt")).split("\n")
  .map { |line| line.split(" ") }

apply_instruction = Proc.new do |previous_positions, (direction, amount)|
  x, d, aim = previous_positions
  case direction
  when "forward"
    [x + Integer(amount), d + (aim * Integer(amount)), aim]
  when "up"
    [x, d, aim - Integer(amount)]
  when "down"
    [x, d, aim + Integer(amount)]
  end
end

initial_positions = [0, 0, 0]
final_positions = input.reduce(initial_positions, &apply_instruction)
p final_positions[0] * final_positions[1]