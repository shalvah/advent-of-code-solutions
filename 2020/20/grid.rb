require 'set'

class Grid
  attr_reader :grid, :used_tile_ids

  def initialize(l)
    @grid = []
    @width = l
    @used_tile_ids = Set.new
  end

  def size
    @used_tile_ids.size
  end

  def row(row)
    @grid[row]
  end

  def set_tile(tile, row, column)
    @grid[row] ||= []
    @grid[row][column] = tile
    @used_tile_ids << tile.id
  end

  def has?(tile)
    @used_tile_ids.include? tile.id
  end

  def ids
    @grid.map do |row|
      if row == nil
        "XXXX " * @width
      else
        line = row.map do |tile|
          if tile == nil
            "XXXX"
          else
            tile.id
          end
        end
        line.join(" ")
      end
    end.join("\n")
  end

  # Print the image
  def image(with_separator: false)
    @grid.map do |row|
      row_content = []
      row.each do |tile|
        tile.image.each_with_index do |line, index|
          row_content[index] ||= []
          row_content[index] << " | " if with_separator
          row_content[index].push(*line)
        end
      end
      row_content
    end.flatten(1)
  end

  def self.print_grid(grid)
    grid.map do |row|
      row.join
    end.join("\n")
  end

  def verify
    @grid.transpose.each do |column|
      column.each_with_index do |tile, index|
        next if index == 0

        if tile.border(:top) != column[index - 1].border(:down)
          raise "Tile #{tile.id} top border does not match previous"
        end
      end
    end

    @grid.each do |row|
      row.each_with_index do |tile, index|
        next if index == 0

        if tile.border(:left) != row[index - 1].border(:right)
          raise "Tile #{tile.id} left border does not match previous"
        end
      end
    end
  end

end
