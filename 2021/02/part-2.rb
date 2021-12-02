input = File.read(File.join(__dir__, "input.txt")).split("\n")

x = 0
d = 0
aim = 0
input.each do |line|
  direction, amount = line.split(" ")
  case direction
  when "forward"
    x += Integer(amount)
    d += aim * Integer(amount)
  when "up"
    aim -= Integer(amount)
  when "down"
    aim += Integer(amount)
  end
end

p x*d