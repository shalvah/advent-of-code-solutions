input = File.read('day_2.txt')

scores = { rock: 1, paper: 2, scissors: 3 }
result_scores = { lose: 0, draw: 3, win: 6 }

def play(them, me)
  case [them, me]
    in [:scissors, :paper] | [:paper, :rock] | [:rock, :scissors]
      :lose
    in [:rock, :paper] | [:paper, :scissors] | [:scissors, :rock]
      :win
    in [same_move, ^same_move] # Or we could use `else`
      :draw
  end
end

# Just for easier readability
transform = lambda do |char|
  {
    "A" => :rock, "B" => :paper, "C" => :scissors,
    "X" => :rock, "Y" => :paper, "Z" => :scissors,
  }[char]
end

all_rounds = input.each_line.map do |round|
  their_move, my_move = round.split(" ").map(&transform)
  scores[my_move] + result_scores[play(their_move, my_move)]
end

# Part 1
p all_rounds.sum


def get_move(them, result)
  case [them, result]
    in [:paper, :lose] | [:scissors, :win] | [:rock, :draw]
      :rock
    in [:scissors, :lose] | [:rock, :win] | [:paper, :draw]
      :paper
    in [:rock, :lose] | [:paper, :win] | [:scissors, :draw]
      :scissors
  end
end

transform = lambda do |char|
  {
    "A" => :rock, "B" => :paper, "C" => :scissors,
    "X" => :lose, "Y" => :draw, "Z" => :win,
  }[char]
end

all_rounds = input.each_line.map do |round|
  their_move, result = round.split(" ").map(&transform)
  result_scores[result] + scores[get_move(their_move, result)]
end

# Part 2
p all_rounds.sum
