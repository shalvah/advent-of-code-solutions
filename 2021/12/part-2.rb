input = File.read(File.join(__dir__, "input.txt")).split("\n").map { |line| line.split("-") }

require 'set'

$paths = {}
input.each do |(p1, p2)|
  $paths[p1] ||= Set.new
  $paths[p2] ||= Set.new
  $paths[p1] << p2
  $paths[p2] << p1
end

def find_paths_to_end(point, visited = [], visited_small_twice_parent = false)
  paths_to_end = []
  visited << point
  $paths[point].each do |pp|
    visited_small_twice_current = visited_small_twice_parent
    current_path = Array.new(visited)

    if pp == "end"
      current_path << "end"
      paths_to_end << current_path
    elsif pp == "start"
      next
    else
      if pp.downcase === pp && current_path.include?(pp)
        next if visited_small_twice_current

        visited_small_twice_current = true
      end
      paths_to_end.push(*find_paths_to_end(pp, current_path, visited_small_twice_current))
    end
  end
  paths_to_end
end

p find_paths_to_end("start").size
