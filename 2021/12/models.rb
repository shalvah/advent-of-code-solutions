class PointRegistry
  def initialize
    @points = {}
  end

  def find(point_name)
    @points[point_name] ||= Point.new(point_name)
  end
end

class Point
  attr_accessor :name, :connections

  def initialize(name)
    @name = name
    @connections = []
  end

  def connect(other_point)
    @connections << other_point
  end

  def is_lowercase?
    name.downcase == name
  end
end

class Path
  attr_reader :path, :small_visits, :visited_small_twice

  def initialize(path = [])
    @path = path
    @small_visits = {}
    @visited_small_twice = false
  end

  def <<(point_name)
    @path << point_name
    if point_name.downcase === point_name
      @small_visits[point_name] = (@small_visits[point_name] || 0) + 1
      if @small_visits[point_name] == 2
        @visited_small_twice = true
      end
    end
  end

  def has_point?(point)
    @path.include? point.name
  end

  def to_a
    @path
  end

  def initialize_copy(other_path)
    @path = other_path.path.clone
    @small_visits = other_path.small_visits.clone
    @small_visits = other_path.small_visits.clone
  end
end

class Finder
  def initialize(point_registry, &already_visited_proc)
    @point_registry = point_registry
    @already_visited_proc = already_visited_proc
  end

  def find_paths(start_point_name, end_point_name, path_so_far = ::Path.new)
    path_so_far << start_point_name
    possibilities = @point_registry.find(start_point_name).connections.reject do |point|
      point.name == "start" || @already_visited_proc.call(point, path_so_far)
    end

    possibilities.flat_map do |next_point|
      if next_point.name === end_point_name
        [*path_so_far.to_a, next_point.name].join(",")
      else
        Finder.new(@point_registry, &@already_visited_proc).find_paths(next_point.name, end_point_name, path_so_far.clone)
      end
    end.reject(&:empty?)
  end
end
