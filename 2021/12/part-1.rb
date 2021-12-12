input = File.read(File.join(__dir__, "input.txt")).split("\n").map { |line| line.split("-") }

require 'set'

$paths = {}
input.each do |(p1, p2)|
  $paths[p1] ||= Set.new
  $paths[p2] ||= Set.new
  $paths[p1] << p2
  $paths[p2] << p1
end

def find_paths_to_end(point, visited = [])
  paths_to_end = []
  visited << point
  $paths[point].each do |pp|
    current_path = Array.new(visited)

    next if pp.downcase === pp && current_path.include?(pp)

    if pp == "end"
      paths_to_end << current_path
    else
      paths_to_end.push(*find_paths_to_end(pp, current_path))
    end
  end
  paths_to_end
end

p find_paths_to_end("start").size