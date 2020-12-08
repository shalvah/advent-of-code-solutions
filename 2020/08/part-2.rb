=begin
--- Part Two ---
After some careful analysis, you believe that exactly one instruction is corrupted.

Somewhere in the program, either a jmp is supposed to be a nop, or a nop is supposed to be a jmp. (No acc instructions were harmed in the corruption of this boot code.)

The program is supposed to terminate by attempting to execute an instruction immediately after the last instruction in the file. By changing exactly one jmp or nop, you can repair the boot code and make it terminate correctly.

For example, consider the same program from above:

nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
If you change the first instruction from nop +0 to jmp +0, it would create a single-instruction infinite loop, never leaving that instruction. If you change almost any of the jmp instructions, the program will still eventually find another jmp instruction and loop forever.

However, if you change the second-to-last instruction (from jmp -4 to nop -4), the program terminates! The instructions are visited in this order:

nop +0  | 1
acc +1  | 2
jmp +4  | 3
acc +3  |
jmp -3  |
acc -99 |
acc +1  | 4
nop -4  | 5
acc +6  | 6
After the last instruction (acc +6), the program terminates by attempting to run the instruction below the last instruction in the file. With this change, after the program terminates, the accumulator contains the value 8 (acc +1, acc +1, acc +6).

Fix the program so that it terminates normally by changing exactly one jmp (to nop) or nop (to jmp). What is the value of the accumulator after the program terminates?
=end

require 'set'

file = File.open("input.txt")
input = file.read

def find_correct program
  i = 0
  while i < program.size
    instruction, delta = program[i].split
    case instruction
    when "jmp"
      modified_program = program.clone
      modified_program[i] = "noop #{delta}"
      result = execute(modified_program)
      return {index: i, accumulator: result[:acc]} if result[:looped] == false
    when "nop"
      # nop
      modified_program = program.clone
      modified_program[i] = "jmp #{delta}"
      result = execute modified_program
      return {index: i, accumulator: result[:acc]} if result[:looped] == false
    end
    i += 1
  end
end

def execute(program)
  visited = Set.new
  i = 0
  acc = 0
  while i < program.size
    return {looped: true} if visited.include? i

    instruction, delta = program[i].split
    visited.add i
    case instruction
    when "acc"
      acc += Integer(delta)
      i += 1
    when "jmp"
      i += Integer(delta)
    else
      # nop
      i += 1
    end
  end
  {looped: false, acc: acc}
end

p find_correct input.split("\n")
