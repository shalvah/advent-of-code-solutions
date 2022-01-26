instructions = File.read(File.join(__dir__, "input.txt")).split("\n").map do |line|
  parsed, _ = line.scan /(\w+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/
  [parsed[0], parsed[1..2].map(&:to_i), parsed[3..4].map(&:to_i), parsed[5..6].map(&:to_i)]
end

class Cuboid
  attr_accessor :x1, :x2, :y1, :y2, :z1, :z2

  def initialize(x, y, z)
    @x1, @x2 = x
    @y1, @y2 = y
    @z1, @z2 = z
  end

  def intersection(other_cuboid)
    x = [[x1, other_cuboid.x1].max, [x2, other_cuboid.x2].min]
    y = [[y1, other_cuboid.y1].max, [y2, other_cuboid.y2].min]
    z = [[z1, other_cuboid.z1].max, [z2, other_cuboid.z2].min]

    return nil if x[1] < x[0] || y[1] < y[0] || z[1] < z[0]
    Cuboid.new(x, y, z)
  end

  def -(other_cuboid)
    overlap = intersection(other_cuboid)
    if overlap == nil
      return [self]
    end

    cuboids = []

    if y1 < overlap.y1
      cuboids << [[x1, x2], [y1, overlap.y1 - 1], [z1, z2]]
    end
    if y2 > overlap.y2
      cuboids << [[x1, x2], [overlap.y2 + 1, y2], [z1, z2]]
    end
    if x1 < overlap.x1
      cuboids << [[x1, overlap.x1 - 1], [overlap.y1, overlap.y2], [z1, z2]]
    end
    if x2 > overlap.x2
      cuboids << [[overlap.x2 + 1, x2], [overlap.y1, overlap.y2], [z1, z2]]
    end
    if z1 < overlap.z1
      cuboids << [[overlap.x1, overlap.x2], [overlap.y1, overlap.y2], [z1, overlap.z1 - 1]]
    end
    if z2 > overlap.z2
      cuboids << [[overlap.x1, overlap.x2], [overlap.y1, overlap.y2], [overlap.z2 + 1, z2]]
    end

    cuboids.map { Cuboid.new(*_1) }
  end

  def volume
    (x2 - x1 + 1) * (y2 - y1 + 1) * (z2 - z1 + 1)
  end

  def inspect
    to_s
  end

  def to_s
    "Cuboid: (#{x1}, #{x2}), (#{y1}, #{y2}), (#{z1}, #{z2})"
  end
end

require 'set'
$on_cuboids = []

def flip_cuboid_on(on_cuboid)
  # First add all the non-overlapping areas, then add the new cuboid
  $on_cuboids = $on_cuboids.flat_map { |cuboid| cuboid - on_cuboid }
  $on_cuboids << on_cuboid
end

def flip_cuboid_off(off_cuboid)
  # For each on cuboid, remove the off cuboid
  $on_cuboids = $on_cuboids.flat_map { |cuboid| cuboid - off_cuboid }
end

instructions.each_with_index do |(command, x, y, z), i|
  cuboid = Cuboid.new(x, y, z)
  if command == "on"
    flip_cuboid_on(cuboid)
  else
    flip_cuboid_off(cuboid)
  end
end

p $on_cuboids.map(&:volume).sum