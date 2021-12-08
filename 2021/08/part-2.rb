input = File.read(File.join(__dir__, "input.txt")).split("\n")

unique_segment_counts = {
  "2" => 1,
  "4" => 4,
  "3" => 7,
  "7" => 8,
}

sum = input.map do |input_line|
  mapped = {}
  unknowns = []

  input_signals, output_signals = input_line.split(" | ").map { |line| line.split }
  input_signals.filter do |v|
    if unique_segment_counts.keys.include? v.length.to_s
      mapped[unique_segment_counts[v.length.to_s]] = v.split("")
    else
      unknowns << v.split("")
    end
  end

  top = mapped[7] - mapped[1] if mapped[7] && mapped[1]
  middle_or_top_left = mapped[4] - mapped[7] if mapped[4] && mapped[7]
  bottom_or_bottom_left = mapped[8] - mapped[4] - top if mapped[8] && mapped[4]

  mapped[0] = [*bottom_or_bottom_left, *mapped[1], *top]
  top_left, middle = [], []

  middle_or_top_left.each do |possibility|
    if unknowns.find { |v| mapped[0].dup.push(possibility).difference(v).size == 0 }
      mapped[0] << possibility
      top_left = [possibility]
    else
      middle = [possibility]
    end
  end

  mapped[2] = [*top, *middle, *bottom_or_bottom_left]
  top_right, bottom_right = [], []
  mapped[1].each do |possibility|
    if unknowns.find { |v| mapped[2].dup.push(possibility).difference(v).size == 0 && v.difference(mapped[2].dup.push(possibility)).size == 0 }
      mapped[2] << possibility
      top_right = [possibility]
    else
      bottom_right = [possibility]
    end
  end

  mapped[9] = [*top, *top_right, *bottom_right, *top_left, *middle]
  bottom, bottom_left = [], []
  bottom_or_bottom_left.each do |possibility|
    if unknowns.find { |v| mapped[9].dup.push(possibility).difference(v).size == 0 }
      mapped[9] << possibility
      bottom = [possibility]
    else
      bottom_left = [possibility]
    end
  end

  mapped[5] = [*top, *top_left, *middle, *bottom_right, *bottom]
  mapped[3] = [*top, *top_right, *middle, *bottom_right, *bottom]
  mapped[6] = [*top, *top_left, *middle, *bottom_right, *bottom, *bottom_left]

  decoded = []
  output_signals.each do |o|
    value = o.split("")
    mapped.each do |k, v|
      if v.size == value.size && v.difference(value).empty? && value.difference(v).empty?
        decoded << k
        break
      end
    end
  end
  decoded.join.to_i
end.sum

p sum


=begin
Useful guide:

  0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg

=end