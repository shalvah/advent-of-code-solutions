$positions = File.read(File.join(__dir__, "input.txt")).split("\n").map(&:split).map(&:last).map(&:to_i)

def wrap(position)
  position % 10 === 0 ? 10 : position % 10
end

$possible_sums = {
  6 => 7, # [[1, 2, 3], [2, 2, 2]],
  5 => 6, # [[1, 2, 2], [1, 1, 3]],
  4 => 3, # [[1, 2, 1]],
  3 => 1, # [[1, 1, 1]],
  7 => 6, # [[1, 3, 3], [2, 2, 3]],
  8 => 3, # [[2, 3, 3]],
  9 => 1, # [[3, 3, 3]],
}
$wins = [0, 0]

def play_turn(player, positions, scores = [0, 0], prev_sums = [])
  universes_in_state = [[], []]
  loop do
    $possible_sums.keys.each do |rolled_sum|
      scores_copy = [*scores]
      positions_copy = [*positions]
      positions_copy[player] = wrap(rolled_sum + positions_copy[player])
      scores_copy[player] += positions_copy[player]

      sums = prev_sums + [rolled_sum]
      universes_in_state[player][sums] = $possible_sums[s]
      if scores_copy[player] >= 21
        $wins[player] += sums.map { |s| $possible_sums[s] }.reduce(:*)
        next
      else
      end
    end
    player = (player + 1) % 2
  end
end

play_turn(0, $positions)

p $wins.max

# Recursion: Correct, but slow
# def play_turn(player, positions, scores = [0, 0], prev_sums = [])
#   $possible_sums.keys.each do |rolled_sum|
#     scores_copy = [*scores]
#     positions_copy = [*positions]
#     positions_copy[player] = wrap(rolled_sum + positions_copy[player])
#     scores_copy[player] += positions_copy[player]
#
#     sums = prev_sums + [rolled_sum]
#     if scores_copy[player] >= 21
#       $wins[player] += sums.map { |s| $possible_sums[s] }.reduce(:*)
#       next
#     else
#       play_turn((player + 1) % 2, positions_copy, scores_copy, sums)
#     end
#   end
# end
#
# play_turn(0, $positions)
#
# p $wins.max