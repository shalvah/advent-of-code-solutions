input = File.read(File.join(__dir__, "input.txt")).split.join("")

$map = {
  "0" => "0000",
  "1" => "0001",
  "2" => "0010",
  "3" => "0011",
  "4" => "0100",
  "5" => "0101",
  "6" => "0110",
  "7" => "0111",
  "8" => "1000",
  "9" => "1001",
  "A" => "1010",
  "B" => "1011",
  "C" => "1100",
  "D" => "1101",
  "E" => "1110",
  "F" => "1111",
}

def parse_packet(packet)
  return [nil, []] if packet.nil? || packet.empty?

  version = packet[0...3].to_i(2)
  type = packet[3...6].to_i(2)

  rest, parsed_packets = nil, []
  if type != 4 # Operator packet
    length_type_id = packet[6].to_i

    all_subpackets = []
    case length_type_id
    when 0
      bits_count = packet[7...22].to_i(2)
      remaining_packets = packet[22...(22 + bits_count)]
      while remaining_packets != nil do
        remaining_packets, subpackets = parse_packet(remaining_packets)
        all_subpackets.push(*subpackets)
      end

      rest = (remaining_packets || "") + (packet[(22 + bits_count)..-1] || "")
    when 1
      subpackets_to_process = packet[7...18].to_i(2)
      rest = packet[18..-1]
      while subpackets_to_process > 0
        rest, subpackets = parse_packet(rest)
        all_subpackets.push(*subpackets)
        subpackets_to_process -= 1
      end
    end

    p all_subpackets
    value = case type
    when 0
      all_subpackets.sum
    when 1
      all_subpackets.reduce(:*)
    when 2
      all_subpackets.min
    when 3
      all_subpackets.max
    when 5
      all_subpackets[0] > all_subpackets[1] ? 1 : 0
    when 6
      all_subpackets[0] < all_subpackets[1] ? 1 : 0
    when 7
      all_subpackets[0] === all_subpackets[1] ? 1 : 0
    end
    parsed_packets << value
  else
    # Literal
    bits = packet[6..-1]
    next_slice_index = 0
    value = ""
    bits.split("").each_slice(5).with_index do |slice, index|
      value += slice[1..-1].join
      next_slice_index = index + 1
      break if slice[0] == "0" # Last value
    end
    parsed_packets << value.to_i(2)

    next_index = next_slice_index * 5
    rest = bits[next_index..-1]
  end

  [rest, parsed_packets]
end

packet = input.split("").map { |char| $map[char] }.join("")
_, packets = parse_packet(packet)
p packets[0]