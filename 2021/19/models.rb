# Monkey-patch because I'm lazy
# This way, the transforms work on Beacon instances or bare arrays
class Array
  def x
    self[0];
  end

  def y
    self[1];
  end

  def z
    self[2];
  end
end

class Scanner
  attr_reader :gaps, :index, :beacons
  attr_accessor :absolute_position, :transforms

  def initialize(index, beacons)
    @index = index
    @beacons = beacons
    @gaps = {}
    compute_gaps

    if index == 0
      @absolute_position = [0, 0, 0]
      @transforms = [->(b) { [b.x, b.y, b.z] }]
    end
  end

  def compute_gaps
    beacons.map do |beacon|
      beacons.map do |other_beacon|
        get_gap(beacon, other_beacon)
      end
    end
  end

  def beacons_gaps
    beacons.map { [_1, gaps[_1]] }
  end

  def get_gap(beacon, other_beacon)
    gaps[beacon] ||= {}
    gaps[beacon][other_beacon] ||= beacon.gap(other_beacon)
  end

  def transform(point)
    @transforms.each { |t| point = t.call(point) }
    point
  end

  def resolve_point(point)
    transform(point).zip(absolute_position).map(&:sum)
  end

  def inspect
    "Scanner #{index}: #{beacons.inspect}"
  end
end

class Beacon
  attr_reader :x, :y, :z, :index

  def initialize(x, y, z, index)
    @x = x
    @y = y
    @z = z
    @index = index
  end

  def gap(other_beacon)
    return 0 if index == other_beacon.index

    ((x - other_beacon.x) ** 2) + ((y - other_beacon.y) ** 2) + ((z - other_beacon.z) ** 2)
  end

  def get_offset(other_beacon, transform)
    x1, y1, z1 = transform.call(other_beacon)
    [x - x1, y - y1, z - z1]
  end

  def inspect
    "(#{x}, #{y}, #{z})"
  end
end

# Could do a matrix multiplication, but meh
TRANSFORMS = [
  ->(b) { [b.x, b.y, b.z] },
  ->(b) { [-b.y, b.x, b.z] },
  ->(b) { [-b.x, -b.y, b.z] },
  ->(b) { [b.y, -b.x, b.z] },

  ->(b) { [-b.x, b.y, -b.z] },
  ->(b) { [-b.y, -b.x, -b.z] },
  ->(b) { [b.x, -b.y, -b.z] },
  ->(b) { [b.y, b.x, -b.z] },

  ->(b) { [-b.z, b.y, b.x] },
  ->(b) { [-b.z, b.x, -b.y] },
  ->(b) { [-b.z, -b.y, -b.x] },
  ->(b) { [-b.z, -b.x, b.y] },

  ->(b) { [b.z, b.y, -b.x] },
  ->(b) { [b.z, -b.x, -b.y] },
  ->(b) { [b.z, -b.y, b.x] },
  ->(b) { [b.z, b.x, b.y] },

  ->(b) { [b.x, b.z, -b.y] },
  ->(b) { [-b.y, b.z, -b.x] },
  ->(b) { [-b.x, b.z, b.y] },
  ->(b) { [b.y, b.z, b.x] },

  ->(b) { [b.x, -b.z, b.y] },
  ->(b) { [-b.y, -b.z, b.x] },
  ->(b) { [-b.x, -b.z, -b.y] },
  ->(b) { [b.y, -b.z, -b.x] },
]
