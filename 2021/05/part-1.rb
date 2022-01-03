input = File.read(File.join(__dir__, "input.txt")).split("\n").map do |line|
  line.split(' -> ').map { |coords| coords.split(',').map(&:to_i) }.flatten
end

$covered = {}
def mark_covered(x, y)
  $covered["#{x},#{y}"] = ($covered["#{x},#{y}"] || 0) + 1
end

input.each do |(x1, y1, x2, y2)|
  if y1 == y2
    range = (x2 > x1) ? (x1..x2) : (x2..x1)
    range.each { |x| mark_covered(x, y1) }
  elsif x1 == x2
    range = (y2 > y1) ? (y1..y2) : (y2..y1)
    range.each { |y| mark_covered(x1, y) }
  end
end

p $covered.filter { |_, lines_count| lines_count >= 2 }.size