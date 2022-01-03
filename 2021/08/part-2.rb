input = File.read(File.join(__dir__, "input.txt")).split("\n")

unique_segment_counts = {
  "2" => 1,
  "4" => 4,
  "3" => 7,
  "7" => 8,
}

sum = input.map do |input_line|
  known = {}
  unknowns = []

  input_signals, output_signals = input_line.split(" | ").map { |line| line.split }
  input_signals.each do |v|
    if unique_segment_counts.keys.include? v.length.to_s
      known[unique_segment_counts[v.length.to_s]] = v.split("")
    else
      unknowns << v.split("")
    end
  end

  #
  # Segments:
  #          top
  # top_left     top_right
  #         middle
  # bottom_left  bottom_right
  #         bottom
  #

  top = known[7] - known[1]
  middle_and_top_left = known[4] - known[7]
  bottom_and_bottom_left = known[8] - known[4] - top
  top_left, middle = [], []
  top_right, bottom_right = [], []
  bottom, bottom_left = [], []

  known[0] = [*top_left, *top, *known[1], *bottom_and_bottom_left]
  middle_and_top_left.each do |possibility|
    # Find top_left (and hence middle)
    if unknowns.find { |v| known[0].dup.push(possibility).difference(v).size == 0 }
      known[0] << possibility
      top_left = [possibility]
    else
      middle = [possibility]
    end
  end

  known[2] = [*top, *top_right, *middle, *bottom_and_bottom_left]
  known[1].each do |segment|
    # Find top_right (and hence bottom_right)
    if unknowns.find { |v| known[2].dup.push(segment).difference(v).size == 0 && v.difference(known[2].dup.push(segment)).size == 0 }
      known[2] << segment
      top_right = [segment]
    else
      bottom_right = [segment]
    end
  end

  known[9] = [*middle, *top_left, *top, *top_right, *bottom_right, *bottom, *bottom_left]
  bottom_and_bottom_left.each do |possibility|
    if unknowns.find { |v| known[9].dup.push(possibility).difference(v).size == 0 }
      known[9] << possibility
      bottom = [possibility]
    else
      bottom_left = [possibility]
    end
  end

  known[5] = [*top, *top_left, *middle, *bottom_right, *bottom]
  known[3] = [*top, *top_right, *middle, *bottom_right, *bottom]
  known[6] = [*top, *top_left, *middle, *bottom_right, *bottom, *bottom_left]

  decoded = []
  output_signals.each do |o|
    value = o.split("")
    known.each do |k, v|
      if v.size == value.size && v.difference(value).empty? && value.difference(v).empty?
        decoded << k
        break
      end
    end
  end
  decoded.join.to_i
end.sum

p sum