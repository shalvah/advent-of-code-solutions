=begin
--- Part Two ---
The air conditioner comes online! Its cold air feels good for a while, but then the TEST alarms start to go off. Since the air conditioner can't vent its heat anywhere but back into the spacecraft, it's actually making the air inside the ship warmer.

Instead, you'll need to use the TEST to extend the thermal radiators. Fortunately, the diagnostic program (your puzzle input) is already equipped for this. Unfortunately, your Intcode computer is not.

Your computer is only missing a few opcodes:

Opcode 5 is jump-if-true: if the first parameter is non-zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
Opcode 6 is jump-if-false: if the first parameter is zero, it sets the instruction pointer to the value from the second parameter. Otherwise, it does nothing.
Opcode 7 is less than: if the first parameter is less than the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
Opcode 8 is equals: if the first parameter is equal to the second parameter, it stores 1 in the position given by the third parameter. Otherwise, it stores 0.
Like all instructions, these instructions need to support parameter modes as described above.

Normally, after an instruction is finished, the instruction pointer increases by the number of values in that instruction. However, if the instruction modifies the instruction pointer, that value is used and the instruction pointer is not automatically increased.

For example, here are several programs that take one input, compare it to the value 8, and then produce one output:

3,9,8,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
3,9,7,9,10,9,4,9,99,-1,8 - Using position mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
3,3,1108,-1,8,3,4,3,99 - Using immediate mode, consider whether the input is equal to 8; output 1 (if it is) or 0 (if it is not).
3,3,1107,-1,8,3,4,3,99 - Using immediate mode, consider whether the input is less than 8; output 1 (if it is) or 0 (if it is not).
Here are some jump tests that take an input, then output 0 if the input was zero or 1 if the input was non-zero:

3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9 (using position mode)
3,3,1105,-1,9,1101,0,0,12,4,12,99,1 (using immediate mode)
Here's a larger example:

3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99
The above example program uses an input instruction to ask for a single number. The program will then output 999 if the input value is below 8, output 1000 if the input value is equal to 8, or output 1001 if the input value is greater than 8.

This time, when the TEST diagnostic program runs its input instruction to get the ID of the system to test, provide it 5, the ID for the ship's thermal radiator controller. This diagnostic test suite only outputs one number, the diagnostic code.

What is the diagnostic code for system ID 5?
=end

def get_opcode_and_parameter_modes(instruction)
  opcode = (instruction[-2..-1] || instruction[0]).to_i # If the instruction is supplied as a single digit
  p1_mode = instruction[-3] || '0'
  p2_mode = instruction[-4] || '0'
  [opcode, p1_mode, p2_mode, ]
end

def get_value_with_mode(value, parameter_mode, program)
  case parameter_mode
  when '0'
    program[value].to_i
  when '1'
    value
  end
end

def compute_output(program)
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
      program[data_position] = get_input
      i += 2
    when 4
      val = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      send_output val
      i += 2
    when 5
      # Jump if true
      val1 = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      if val1 != 0 then
        val2 = get_value_with_mode(program[i + 2].to_i, p2_mode, program)
        i = val2
      else
        i += 3
      end
    when 6
      # Jump if false
      val1 = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      if val1 == 0 then
        val2 = get_value_with_mode(program[i + 2].to_i, p2_mode, program)
        i = val2
      else
        i += 3
      end
    when 7
      val1 = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      val2 = get_value_with_mode(program[i + 2].to_i, p2_mode, program)
      result_position = program[i + 3].to_i
      if val1 < val2 then
        program[result_position] = '1'
      else
        program[result_position] = '0'
      end
      i += 4
    when 8
      val1 = get_value_with_mode(program[i + 1].to_i, p1_mode, program)
      val2 = get_value_with_mode(program[i + 2].to_i, p2_mode, program)
      result_position = program[i + 3].to_i
      if val1 == val2 then
        program[result_position] = '1'
      else
        program[result_position] = '0'
      end
      i += 4
    end
  end
  program.join(',')
end

def get_input
  5
end

def send_output (value)
  p value
end

file = File.open("input.txt")
program = file.read.split(',')
compute_output(program)
