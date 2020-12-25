require './transformer'

include Transformer

class Tile
  @@border_positions = [:left, :top, :right, :bottom]
  @@flipped_border_positions = [:flipped_left, :flipped_top, :flipped_right, :flipped_bottom,]

  attr_reader :id, :orientation, :borders, :flips_horizontal, :flips_vertical

  def initialize(text)
    first_line, *rest = text.split("\n")
    @id = first_line.scan(/\d+/)[0]
    @top_border, *@original_inner_contents, @bottom_border = rest
    # All borders are read L-R or T-D
    @left_border = rest.map { |str| str[0] }.join
    @right_border = rest.map { |str| str[-1] }.join
    @borders = [@left_border, @top_border, @right_border, @bottom_border,]

    @flips_vertical = 0
    @flips_horizontal = 0
    @orientation = 0
    # Trim borders
    @original_inner_contents = @original_inner_contents.map { |str| str[1, str.size - 2].split("") }
    @shared_borders = {}
  end

  def match_border(border)
    @@border_positions[@borders.find_index(border)]
  end

  def has_border(border)
    @borders.include?(border)
  end

  def is_corner(corners)
    corners.include?(@id)
  end

  # Rotate by 90 degrees clockwise
  def rotate
    @orientation += 90
    border = @borders.pop
    @borders.unshift border

    # We need to do this because we read each border from L-R and T-B
    # So when the left border AB moves into top position, it should be BA
    top = @@border_positions.find_index(:top)
    bottom = @@border_positions.find_index(:bottom)
    @borders[top] = @borders[top].reverse
    @borders[bottom] = @borders[bottom].reverse
  end

  # Flip around the vertical plane
  def flip_vertical
    top = @@border_positions.find_index(:top)
    bottom = @@border_positions.find_index(:bottom)
    @borders[top] = @borders[top].reverse
    @borders[bottom] = @borders[bottom].reverse

    left = @@border_positions.find_index(:left)
    right = @@border_positions.find_index(:right)
    bl = @borders[left]
    br = @borders[right]
    @borders[left] = br
    @borders[right] = bl

    @flips_vertical += 1
  end

  # Flip around the horizontal plane
  def flip_horizontal
    left = @@border_positions.find_index(:left)
    right = @@border_positions.find_index(:right)
    # Remember, borders are read clockwise
    @borders[left] = @borders[left].reverse
    @borders[right] = @borders[right].reverse

    top = @@border_positions.find_index(:top)
    bottom = @@border_positions.find_index(:bottom)
    bt = @borders[top]
    bb = @borders[bottom]
    @borders[top] = bb
    @borders[bottom] = bt

    @flips_horizontal += 1
  end

  def get_all_shared_borders(identicals)
    normal = @@border_positions.zip(@borders.map do |border_content|
      border_positions = identicals[border_content]
      border_positions.reject { |(tile_id, pos)| tile_id == @id }
    end)
    when_flipped = @@flipped_border_positions.zip(@borders.map do |border_content|
      border_positions = identicals[border_content.reverse]
      if border_positions == nil
        next []
      end
      border_positions.reject { |(tile_id, pos)| tile_id == @id }
    end)
    (normal + when_flipped).to_h
  end

  def find_possible_neighbours(identicals, direction = :right, excluding_tiles = [])
    exclude = excluding_tiles + [@id]
    case direction
    when :right
      right = @@border_positions.find_index(:right)
      border = @borders[right]
    when :down
      bottom = @@border_positions.find_index(:bottom)
      border = @borders[bottom]
    end

    # Assumption: there's exactly one neighbour
    neighbours = (identicals[border] || []).select { |(tile_id, pos)| !exclude.include?(tile_id) }
    reversed = false
    if neighbours.empty?
      neighbours = (identicals[border.reverse] || []).select { |(tile_id, pos)| !exclude.include?(tile_id) }
      reversed = true
    end

    return nil if neighbours.empty?

    return {
        id: neighbours[0][0],
        position: neighbours[0][1],
        reversed: reversed
    }
  end

  def border(direction)
    case direction
    when :right
      right = @@border_positions.find_index(:right)
      border = @borders[right]
      border.split("").join("\n")
    when :left
      left = @@border_positions.find_index(:left)
      border = @borders[left]
      border.split("").join("\n")
    when :down
      bottom = @@border_positions.find_index(:bottom)
      border = @borders[bottom]
    when :top
      top = @@border_positions.find_index(:top)
      border = @borders[top]
    end
  end

  # Print the tile (without borders)
  def image
    # The rows of the original tile
    contents = @original_inner_contents.clone

    flipped_h = @flips_horizontal % 2 == 1
    flipped_v = @flips_vertical % 2 == 1
    orientation = @orientation % 360

    # Apply orientation
    # Assume original is
    #  A B C
    #  D E F
    #  G H I
    case orientation
    when 0
      # We're good
    when 90
      #  G D A
      #  H E B
      #  I F C
      contents = Transformer::rotate_90(contents)
    when 180
      #  I H G
      #  F E D
      #  C B A
      contents = Transformer::rotate_180(contents)
    when 270
      #  C F I
      #  B E H
      #  A D G
      contents = Transformer::rotate_270(contents)
    end

    # Apply flips
    if flipped_v
      contents = Transformer::flip_vertical(contents)
    end
    if flipped_h
      contents = Transformer::flip_horizontal(contents)
    end
    contents
  end

end
