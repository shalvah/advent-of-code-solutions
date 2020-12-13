class Intcode
  attr_reader :output, :ended

  def initialize(input, get_input, send_output)
    @input = input
    @get_input = get_input
    @send_output = send_output
    @relative_base = 0
    @output = []
    @ended = false
  end

  def get_opcode_and_parameter_modes(instruction)
    opcode = (instruction[-2..-1] || instruction[0]).to_i # The instruction is supplied as 1 - 5 digits
    p1_mode = instruction[-3] || '0'
    p2_mode = instruction[-4] || '0'
    p3_mode = instruction[-5] || '0'
    [opcode, p1_mode, p2_mode, p3_mode]
  end

  def get_value_with_mode(parameter, parameter_mode)
    case parameter_mode
    when '0' # Position mode
      @input[parameter].to_i # Any memory beyond bounds will return nil, which to_i makes 0, so we're good
    when '1' # Immediate mode
      parameter
    when '2' # Relative mode
      @input[parameter + @relative_base].to_i
    end
  end

  def get_output_address_with_mode(parameter, parameter_mode)
    case parameter_mode
    when '0' # Position mode
      parameter
    when '2' # Relative mode
      parameter + @relative_base
    end
  end

  def execute
    i = 0
    while i < @input.size
      opcode, p1_mode, p2_mode, p3_mode = get_opcode_and_parameter_modes(@input[i])

      case opcode
      when 99 # End
        @ended = true
        return @input.join(',')
      when 1 # Add
        val1 = get_value_with_mode(@input[i + 1].to_i, p1_mode)
        val2 = get_value_with_mode(@input[i + 2].to_i, p2_mode)
        result_position = get_output_address_with_mode(@input[i + 3].to_i, p3_mode)
        @input[result_position] = (val1 + val2).to_s
        i += 4
      when 2 # Multiply
        val1 = get_value_with_mode(@input[i + 1].to_i, p1_mode)
        val2 = get_value_with_mode(@input[i + 2].to_i, p2_mode)
        result_position = get_output_address_with_mode(@input[i + 3].to_i, p3_mode)
        @input[result_position] = (val1 * val2).to_s
        i += 4
      when 3 # Get input and store
        data_position = get_output_address_with_mode(@input[i + 1].to_i, p1_mode)
        @input[data_position] = @get_input.call
        i += 2
      when 4 # Send output
        val = get_value_with_mode(@input[i + 1].to_i, p1_mode)
        # For logging purposes: store in our internal output
        @output << val
        @send_output.call(val)
        i += 2
      when 5
        # Jump if true
        val1 = get_value_with_mode(@input[i + 1].to_i, p1_mode)
        if val1 != 0
          val2 = get_value_with_mode(@input[i + 2].to_i, p2_mode)
          i = val2
        else
          i += 3
        end
      when 6
        # Jump if false
        val1 = get_value_with_mode(@input[i + 1].to_i, p1_mode)
        if val1 == 0
          val2 = get_value_with_mode(@input[i + 2].to_i, p2_mode)
          i = val2
        else
          i += 3
        end
      when 7
        val1 = get_value_with_mode(@input[i + 1].to_i, p1_mode)
        val2 = get_value_with_mode(@input[i + 2].to_i, p2_mode)
        result_position = get_output_address_with_mode(@input[i + 3].to_i, p3_mode)
        @input[result_position] = if val1 < val2 then '1' else '0' end
        i += 4
      when 8
        val1 = get_value_with_mode(@input[i + 1].to_i, p1_mode)
        val2 = get_value_with_mode(@input[i + 2].to_i, p2_mode)
        result_position = get_output_address_with_mode(@input[i + 3].to_i, p3_mode)
        @input[result_position] = if val1 == val2 then '1' else '0' end
        i += 4
      when 9 # Relative base offset
        val1 = get_value_with_mode(@input[i + 1].to_i, p1_mode)
        @relative_base += val1
        i += 2
      end
    end
    @input.join(',')
  end

end
