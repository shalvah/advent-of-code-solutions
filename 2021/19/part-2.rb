scanners_readings = File.read(File.join(__dir__, "input.txt")).split("\n\n").map do |group|
  group.split("\n")[1..-1].map { |coords| coords.split(",").map(&:to_i) }
end

### Same as Part 1...
require_relative './models'

scanners = scanners_readings.map.with_index do |readings, scanner_index|
  beacons = readings.map.with_index do |beacon_coords, beacon_index|
    Beacon.new(*beacon_coords, beacon_index)
  end
  Scanner.new(scanner_index, beacons)
end

scanners_to_process = scanners.dup
resolved_scanners = [scanners_to_process.shift]
get_scanner = scanners_to_process.cycle

until resolved_scanners.compact.size == scanners.size
  scanner = get_scanner.next
  next if resolved_scanners.include?(scanner)

  overlapping_beacons = []
  overlapping_scanner = nil
  resolved_scanners.compact.each do |resolved_scanner|
    # Find beacons that have the same set of distances from others
    overlapping_beacons = scanner.beacons_gaps.map do |(beacon, gaps)|
      matching = resolved_scanner.beacons_gaps.find do |(other_beacon, other_gaps)|
        gaps.values.intersection(other_gaps.values).size >= 12
      end
      matching ? [beacon, matching[0]] : nil
    end.compact
    break (overlapping_scanner = resolved_scanner) if !overlapping_beacons.empty?
  end

  next if overlapping_beacons.empty?

  pos_wrt_other = nil
  # The correct transform is the one where the distance is constant
  winning_transform = TRANSFORMS.find do |transform|
    offsets = overlapping_beacons[0..1].map do |b, other_b|
      other_b.get_offset(b, transform)
    end

    if offsets.uniq.size == 1
      pos_wrt_other = offsets[0]
      true
    end
  end

  scanner.absolute_position = overlapping_scanner.resolve_point(pos_wrt_other)
  scanner.transforms = [winning_transform, *overlapping_scanner.transforms]
  resolved_scanners[scanner.index] = scanner
end

### The real Part 2
distances = scanners.combination(2).map do |s1, s2|
  s1.absolute_position.zip(s2.absolute_position).map { |(a, b)| (a - b).abs }.sum
end

p distances.max