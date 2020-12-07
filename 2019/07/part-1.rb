=begin
--- Day 7: Amplification Circuit ---
Based on the navigational maps, you're going to need to send more power to your ship's thrusters to reach Santa in time. To do this, you'll need to configure a series of amplifiers already installed on the ship.

There are five amplifiers connected in series; each one receives an input signal and produces an output signal. They are connected such that the first amplifier's output leads to the second amplifier's input, the second amplifier's output leads to the third amplifier's input, and so on. The first amplifier's input value is 0, and the last amplifier's output leads to your ship's thrusters.

    O-------O  O-------O  O-------O  O-------O  O-------O
0 ->| Amp A |->| Amp B |->| Amp C |->| Amp D |->| Amp E |-> (to thrusters)
    O-------O  O-------O  O-------O  O-------O  O-------O
The Elves have sent you some Amplifier Controller Software (your puzzle input), a program that should run on your existing Intcode computer. Each amplifier will need to run a copy of the program.

When a copy of the program starts running on an amplifier, it will first use an input instruction to ask the amplifier for its current phase setting (an integer from 0 to 4). Each phase setting is used exactly once, but the Elves can't remember which amplifier needs which phase setting.

The program will then call another input instruction to get the amplifier's input signal, compute the correct output signal, and supply it back to the amplifier with an output instruction. (If the amplifier has not yet received an input signal, it waits until one arrives.)

Your job is to find the largest output signal that can be sent to the thrusters by trying every possible combination of phase settings on the amplifiers. Make sure that memory is not shared or reused between copies of the program.

For example, suppose you want to try the phase setting sequence 3,1,2,4,0, which would mean setting amplifier A to phase setting 3, amplifier B to setting 1, C to 2, D to 4, and E to 0. Then, you could determine the output signal that gets sent from amplifier E to the thrusters with the following steps:

Start the copy of the amplifier controller software that will run on amplifier A. At its first input instruction, provide it the amplifier's phase setting, 3. At its second input instruction, provide it the input signal, 0. After some calculations, it will use an output instruction to indicate the amplifier's output signal.
Start the software for amplifier B. Provide it the phase setting (1) and then whatever output signal was produced from amplifier A. It will then produce a new output signal destined for amplifier C.
Start the software for amplifier C, provide the phase setting (2) and the value from amplifier B, then collect its output signal.
Run amplifier D's software, provide the phase setting (4) and input value, and collect its output signal.
Run amplifier E's software, provide the phase setting (0) and input value, and collect its output signal.
The final output signal from amplifier E would be sent to the thrusters. However, this phase setting sequence may not have been the best one; another sequence might have sent a higher signal to the thrusters.

Here are some example programs:

Max thruster signal 43210 (from phase setting sequence 4,3,2,1,0):

3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0
Max thruster signal 54321 (from phase setting sequence 0,1,2,3,4):

3,23,3,24,1002,24,10,24,1002,23,-1,23,
101,5,23,23,1,24,23,23,4,23,99,0,0
Max thruster signal 65210 (from phase setting sequence 1,0,4,3,2):

3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,
1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0
Try every combination of phase settings on the amplifiers. What is the highest signal that can be sent to the thrusters?
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
  when '1'
    value
  end
end

def run_intcode(program, output, &get_input)
  i = 0
  while i < program.size
    opcode, p1_mode, p2_mode = get_opcode_and_parameter_modes(program[i])

    case opcode
    when 99
      return program.join(',')
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
      data_position = program[i + 1].to_i
      program[data_position] = yield # Get input via whatever input function was passed
      i += 2
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
  program.join(',')
end

def compute_thruster_signal(program, amplifiers)
  input_signal = 0
  amplifiers.each do |phase_setting|
    output = []
    inputs = Enumerator.new do |yielder|
      yielder.yield phase_setting
      yielder.yield input_signal
    end
    run_intcode(program, output) { inputs.next }
    input_signal = output[0]
  end
  input_signal
end

file = File.open("input.txt")
program = file.read.split(',')

# Generate the 5! = 120 possible settings
# Each setting can only appear once
phase_settings = []
for a in (0..4)
  for b in (0..4)
    next if b == a
    for c in (0..4)
      next if [a, b].include?(c)
      for d in (0..4)
        next if [a, b, c].include?(d)
        for e in (0..4)
          next if [a, b, c, d].include?(e)
          phase_settings << [a, b, c, d, e]
        end
      end
    end
  end
end


max_thruster = 0
phase_settings.each do |amplifiers|
  program_copy = program.clone # Rest memory
  thruster = compute_thruster_signal(program_copy, amplifiers)
  max_thruster = thruster if thruster > max_thruster
end
p max_thruster
