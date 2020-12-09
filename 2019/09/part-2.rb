=begin
--- Part Two ---
You now have a complete Intcode computer.

Finally, you can lock on to the Ceres distress signal! You just need to boost your sensors using the BOOST program.

The program runs in sensor boost mode by providing the input instruction the value 2. Once run, it will boost the sensors automatically, but it might take a few seconds to complete the operation on slower hardware. In sensor boost mode, the program will output a single value: the coordinates of the distress signal.

Run the BOOST program in sensor boost mode. What are the coordinates of the distress signal?
=end

require './intcode'

file = File.open("input.txt")
input = file.read.split(',')

input_fn = lambda { 2 }
output_fn = lambda { |output| p output }
program = Intcode.new(input, input_fn, output_fn)
program.execute
