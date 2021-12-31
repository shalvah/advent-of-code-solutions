positions = File.read(File.join(__dir__, "input.txt")).split("\n").map(&:split).map(&:last).map(&:to_i)

scores = [0, 0]

def wrap(position)
  position % 10 === 0 ? 10 : position % 10
end

die = (1..100).each_slice(3)
player, turns = 0, 0
loop do
  turns += 1
  rolled = die.next
  positions[player] = wrap(rolled.sum + positions[player])
  scores[player] += positions[player]

  break if scores[player] >= 1000
  player = (player + 1) % 2
end

p turns * 3 * scores[(player + 1) % 2]