=begin
--- Part Two ---
The game didn't run because you didn't put in any quarters. Unfortunately, you did not bring any quarters. Memory address 0 represents the number of quarters that have been inserted; set it to 2 to play for free.

The arcade cabinet has a joystick that can move left and right. The software reads the position of the joystick with input instructions:

If the joystick is in the neutral position, provide 0.
If the joystick is tilted to the left, provide -1.
If the joystick is tilted to the right, provide 1.
The arcade cabinet also has a segment display capable of showing a single number that represents the player's current score. When three output instructions specify X=-1, Y=0, the third output instruction is not a tile; the value instead specifies the new score to show in the segment display. For example, a sequence of output values like -1,0,12345 would show 12345 as the player's current score.

Beat the game by breaking all the blocks. What is your score after the last block is broken?
=end

require './intcode'

paddle = [], ball = []

get_input = lambda do
  # Here, we specify the direction to move the paddle in
  if ball[0] > paddle[0] # Ball to the right of paddle, so move paddle right
    1
  elsif ball[0] < paddle[0]  # Ball to the left of paddle, so move paddle left
    -1
  else
    0
  end
end

score = 0
outputs = []
send_output = lambda do |out|
  outputs << out
  if outputs.size == 3
    x, y, tile = outputs

    # Flush outputs
    outputs = []

    if x == -1 && y == 0
      score = out
      return
    end

    paddle = [x, y] if out == 3
    ball = [x, y] if out == 4
  end

end

file = File.open("input.txt")
input = file.read.split(",")
input[0] = "2"
program = Intcode.new(input, get_input, send_output)
program.execute

p score
