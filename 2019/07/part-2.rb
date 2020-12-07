=begin
--- Part Two ---
It's no good - in this configuration, the amplifiers can't generate a large enough output signal to produce the thrust you'll need. The Elves quickly talk you through rewiring the amplifiers into a feedback loop:

      O-------O  O-------O  O-------O  O-------O  O-------O
0 -+->| Amp A |->| Amp B |->| Amp C |->| Amp D |->| Amp E |-.
   |  O-------O  O-------O  O-------O  O-------O  O-------O |
   |                                                        |
   '--------------------------------------------------------+
                                                            |
                                                            v
                                                     (to thrusters)
Most of the amplifiers are connected as they were before; amplifier A's output is connected to amplifier B's input, and so on. However, the output from amplifier E is now connected into amplifier A's input. This creates the feedback loop: the signal will be sent through the amplifiers many times.

In feedback loop mode, the amplifiers need totally different phase settings: integers from 5 to 9, again each used exactly once. These settings will cause the Amplifier Controller Software to repeatedly take input and produce output many times before halting. Provide each amplifier its phase setting at its first input instruction; all further input/output instructions are for signals.

Don't restart the Amplifier Controller Software on any amplifier during this process. Each one should continue receiving and sending signals until it halts.

All signals sent or received in this process will be between pairs of amplifiers except the very first signal and the very last signal. To start the process, a 0 signal is sent to amplifier A's input exactly once.

Eventually, the software on the amplifiers will halt after they have processed the final loop. When this happens, the last output signal from amplifier E is sent to the thrusters. Your job is to find the largest output signal that can be sent to the thrusters using the new phase settings and feedback loop arrangement.

Here are some example programs:

Max thruster signal 139629729 (from phase setting sequence 9,8,7,6,5):

3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,
27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5
Max thruster signal 18216 (from phase setting sequence 9,7,8,5,6):

3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,
-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,
53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10
Try every combination of the new phase settings on the amplifier feedback loop. What is the highest signal that can be sent to the thrusters?
=end

def get_opcode_and_parameter_modes(instruction)
  opcode = (instruction[-2..-1] || instruction[0]).to_i # If the instruction is supplied as a single digit
  p1_mode = instruction[-3] || '0'
  p2_mode = instruction[-4] || '0'
  [opcode, p1_mode, p2_mode,]
end

def get_value_with_mode(value, parameter_mode, program)
  case parameter_mode
  when '0'
    program[value].to_i
  else
    value
  end
end

# This id parameter is totally not necessary
# # I just use it to keep track of the current amp, for debugging
def run_intcode(id, program, output, start_from = 0, &get_input)
  i = start_from
  while i < program.size
    opcode, p1_mode, p2_mode = get_opcode_and_parameter_modes(program[i])

    case opcode
    when 99
      return true
    when 1
      val1 = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      val2 = get_value_with_mode(program[i + 2].to_i, p2_mode, program)
      result_position = program[i + 3].to_i
      program[result_position] = (val1 + val2).to_s
      i += 4
    when 2
      val1 = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      val2 = get_value_with_mode(program[i + 2].to_i, p2_mode, program)
      result_position = program[i + 3].to_i
      program[result_position] = (val1 * val2).to_s
      i += 4
    when 3
      next_input = yield # Get input via whatever input function was passed
      # puts "ID = #{id}, Next is #{next_input}, i = #{i}"
      if next_input != false
        data_position = program[i + 1].to_i
        program[data_position] = next_input
        i += 2
      else
        return {start_from: i}
      end
    when 4
      val = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      output << val
      i += 2
    when 5
      # Jump if true
      val1 = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      if val1 != 0
        val2 = get_value_with_mode(program[i + 2].to_i, p2_mode, program)
        i = val2
      else
        i += 3
      end
    when 6
      # Jump if false
      val1 = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      if val1 == 0
        val2 = get_value_with_mode(program[i + 2].to_i, p2_mode, program)
        i = val2
      else
        i += 3
      end
    when 7
      val1 = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      val2 = get_value_with_mode(program[i + 2].to_i, p2_mode, program)
      result_position = program[i + 3].to_i
      if val1 < val2
        program[result_position] = '1'
      else
        program[result_position] = '0'
      end
      i += 4
    when 8
      val1 = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      val2 = get_value_with_mode(program[i + 2].to_i, p2_mode, program)
      result_position = program[i + 3].to_i
      if val1 == val2
        program[result_position] = '1'
      else
        program[result_position] = '0'
      end
      i += 4
    end
  end
end

def compute_thruster_signal(program, amplifiers)
  outputs = {}

  queue = {}
  amplifiers.each_with_index do |phase_setting, index|
    # Each amplifier has to save and continue its own state
    queue[index] = {
        start_from: 0,
        program_state: program.clone,
        setting: phase_setting,
    }
  end

  while !queue.empty?
    queue.each do |index, data|
      if index == 0
        input_signal = outputs[4] || 0
      else
        input_signal = outputs[index - 1]
      end

      output = []
      inputs = Enumerator.new do |yielder|
        if data[:setting] != nil
          # The phase setting should only be yielded the first time
          yielder.yield data[:setting]
          data[:setting] = nil
        end
        yielder.yield input_signal
        yielder.yield false # No more inputs available now; pause and wait for next output
      end
      result = run_intcode(index, data[:program_state], output, data[:start_from]) { inputs.next }
      outputs[index] = output.pop
      # puts "Output is #{outputs[index]}"

      if result == true && index == 4 # Finished execution
        queue.delete index
        return outputs[index]
      elsif result.is_a?(Hash) && result[:start_from] # Paused for input
        queue[index][:start_from] = result[:start_from]
      else
        queue.delete index # Remove amp from execution queue
      end
    end
  end
end

file = File.open("input.txt")
program = file.read.split(',')

# Generate the 5! = 120 possible settings
# Each setting can only appear once
# Generate the 5! = 120 possible settings
# Each setting can only appear once
phase_settings = []
for a in (5..9)
  for b in (5..9)
    next if b == a
    for c in (5..9)
      next if [a, b].include?(c)
      for d in (5..9)
        next if [a, b, c].include?(d)
        for e in (5..9)
          next if [a, b, c, d].include?(e)
          phase_settings << [a, b, c, d, e]
        end
      end
    end
  end
end

max_thruster = 0
phase_settings.each do |amplifiers|
  program_copy = program.clone # new copy of program
  thruster = compute_thruster_signal(program_copy, amplifiers)
  max_thruster = thruster if thruster > max_thruster
end

p max_thruster
