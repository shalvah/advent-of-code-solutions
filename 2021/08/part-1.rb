input = File.read(File.join(__dir__, "input.txt")).split("\n")

unique_segment_counts = {
  "2" => 1,
  "4" => 4,
  "3" => 7,
  "7" => 8,
}

count = input.map do |input_line|
  input_signals, output_signals = input_line.split(" | ").map{ |line| line.split }
  output_signals.filter do |v|
    unique_segment_counts[v.length.to_s] != nil
  end.size
end.sum

p count