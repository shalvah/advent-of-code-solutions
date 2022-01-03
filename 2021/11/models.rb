require 'set'

class Grid
  def initialize(octopi)
    @octopi = octopi
  end

  def get_neighbours(x, y)
    below = [x, y + 1] rescue nil
    right = [x + 1, y] rescue nil
    left = [x - 1, y] rescue nil
    above = [x, y - 1] rescue nil
    left_below = [x - 1, y + 1] rescue nil
    left_above = [x - 1, y - 1] rescue nil
    right_below = [x + 1, y + 1] rescue nil
    right_above = [x + 1, y - 1] rescue nil

    [
      (below if y < @octopi.size - 1),
      (above if y > 0),
      (left if x > 0),
      (right if x < @octopi[y].size - 1),
      (left_below if x > 0 && y < @octopi.size - 1),
      (left_above if x > 0 && y > 0),
      (right_below if x < @octopi[y].size - 1 && y < @octopi.size - 1),
      (right_above if x < @octopi[y].size - 1 && y > 0),
    ].compact.map { |(x, y)| @octopi[y][x] }
  end

  def size
    @octopi.size * @octopi[0].size
  end
end

class Octopus
  attr_accessor :energy_level, :neighbours

  def initialize(energy_level, x, y)
    @energy_level = energy_level.to_i
    @x = x
    @y = y
  end

  def neighbours(grid)
    @neighbours || grid.get_neighbours(@x, @y)
  end
end

class Flasher
  def initialize(grid)
    @flashed = Set.new
    @grid = grid
  end

  def flash(octopus)
    @flashed << octopus
    octopus.neighbours(@grid).each do |neighbour|
      neighbour.energy_level += 1
      flash(neighbour) if can_be_flashed(neighbour)
    end
  end

  def can_be_flashed(octopus)
    octopus.energy_level > 9 && !has_flashed(octopus)
  end

  def has_flashed(octopus)
    @flashed.include? octopus
  end

  def reset
    @flashed.each { |octopus| octopus.energy_level = 0 }
  end

  def number_of_flashes
    @flashed.size
  end

  def all_flashed
    number_of_flashes === @grid.size
  end
end
