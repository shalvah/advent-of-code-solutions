input = File.read('day_2.txt')

$scores = { "rock" => 1, "paper" => 2, "scissors" => 3 }
$result_scores = { "lose" => 0, "draw" => 3, "win" => 6 }

def play(them, me)
  case [me, them]
    in ["scissors", "paper"] | ["paper", "rock"] | ["rock", "scissors"]
      $result_scores["win"]
    in ["rock", "paper"] | ["paper", "scissors"] | ["scissors", "rock"]
      $result_scores["lose"]
    in [same_play, ^same_play] # Or we could use `else`
      $result_scores["draw"]
  end
end

# Just for easier readability
transform = lambda do |char|
  {
    "A" => "rock",
    "B" => "paper",
    "C" => "scissors",
    "X" => "rock",
    "Y" => "paper",
    "Z" => "scissors",
  }[char]
end

all_rounds = input.each_line.map do |round|
  moves = round.split(" ").map(&transform)
  $scores[moves[1]] + play(*moves)
end

# Part 1
p all_rounds.sum


def find_play(them, result)
  case [them, result]
    in ["paper", "lose"] | ["scissors", "win"] | ["rock", "draw"]
      $scores["rock"]
    in ["scissors", "lose"] | ["rock", "win"] | ["paper", "draw"]
      $scores["paper"]
    in ["rock", "lose"] | ["paper", "win"] | ["scissors", "draw"]
      $scores["scissors"]
  end
end


transform = lambda do |char|
  {
    "A" => "rock",
    "B" => "paper",
    "C" => "scissors",
    "X" => "lose",
    "Y" => "draw",
    "Z" => "win",
  }[char]
end

all_rounds = input.each_line.map do |round|
  their_move, result = round.split(" ").map(&transform)
  $result_scores[result] + find_play(their_move, result)
end

# Part 2
p all_rounds.sum
