input = File.read(File.join(__dir__, "input.txt")).split("\n")

x = 0
d = 0
input.each do |line|
  direction, amount = line.split(" ")
  case direction
  when "forward"
    x += Integer(amount)
  when "up"
    d -= Integer(amount)
  when "down"
    d += Integer(amount)
  end
end

p x*d