input = File.read(File.join(__dir__, "input.txt")).split("\n").map { |line| line.split("-") }

require_relative './models'

all_points = PointRegistry.new
input.each do |(p1, p2)|
  all_points.find(p1).connect(all_points.find(p2))
  all_points.find(p2).connect(all_points.find(p1))
end

already_visited = Proc.new do |p, path_so_far|
  p.is_lowercase? ? path_so_far.has_point?(p) : false
end
paths = Finder.new(all_points, &already_visited).find_paths("start", "end")
p paths.size

=begin
# Procedural version:

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
=end
