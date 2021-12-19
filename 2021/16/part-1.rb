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
  p "version: #{version} type: #{type}"
  if type != 4 # Operator packet
    length_type_id = packet[6].to_i

    p "length_type_id: #{length_type_id}"
    case length_type_id
    when 0
      bits_count = packet[7...22].to_i(2)
      p "bits_count: #{packet[7...22]} (#{bits_count})"
      remaining_packets = packet[22...(22 + bits_count)]
      while remaining_packets != nil do
        remaining_packets, subpackets = parse_packet(remaining_packets)
        parsed_packets.push(*subpackets)
      end
      parsed_packets << [version, "0"]

      rest = (remaining_packets || "") + (packet[(22 + bits_count)..-1] || "")
    when 1
      parsed_packets << [version, "0"]

      subpackets_to_process = packet[7...18].to_i(2)
      rest = packet[18..-1]
      while subpackets_to_process > 0
        rest, subpackets = parse_packet(rest)
        parsed_packets.push(*subpackets)
        subpackets_to_process -= 1
      end
    end
  else
    # Literal
    bits = packet[6..-1]
    next_slice_index = 0
    parsed_packets << [version, ""]
    bits.split("").each_slice(5).with_index do |slice, index|
      parsed_packets.last[1] += slice[1..-1].join
      next_slice_index = index + 1
      break if slice[0] == "0" # Last value
    end

    next_index = next_slice_index * 5
    rest = bits[next_index..-1]
  end

  [rest, parsed_packets]
end

packet = input.split("").map { |char| $map[char] }.join("")
_, packets = parse_packet(packet)
p packets.map { |(version, value)| version }.sum