=begin
--- Part Two ---
Now, you're ready to check the image for sea monsters.

The borders of each tile are not part of the actual image; start by removing them.

In the example above, the tiles become:

.#.#..#. ##...#.# #..#####
###....# .#....#. .#......
##.##.## #.#.#..# #####...
###.#### #...#.## ###.#..#
##.#.... #.##.### #...#.##
...##### ###.#... .#####.#
....#..# ...##..# .#.###..
.####... #..#.... .#......

#..#.##. .#..###. #.##....
#.####.. #.####.# .#.###..
###.#.#. ..#.#### ##.#..##
#.####.. ..##..## ######.#
##..##.# ...#...# .#.#.#..
...#..#. .#.#.##. .###.###
.#.#.... #.##.#.. .###.##.
###.#... #..#.##. ######..

.#.#.### .##.##.# ..#.##..
.####.## #.#...## #.#..#.#
..#.#..# ..#.#.#. ####.###
#..####. ..#.#.#. ###.###.
#####..# ####...# ##....##
#.##..#. .#...#.. ####...#
.#.###.. ##..##.. ####.##.
...###.. .##...#. ..#..###
Remove the gaps to form the actual image:

.#.#..#.##...#.##..#####
###....#.#....#..#......
##.##.###.#.#..######...
###.#####...#.#####.#..#
##.#....#.##.####...#.##
...########.#....#####.#
....#..#...##..#.#.###..
.####...#..#.....#......
#..#.##..#..###.#.##....
#.####..#.####.#.#.###..
###.#.#...#.######.#..##
#.####....##..########.#
##..##.#...#...#.#.#.#..
...#..#..#.#.##..###.###
.#.#....#.##.#...###.##.
###.#...#..#.##.######..
.#.#.###.##.##.#..#.##..
.####.###.#...###.#..#.#
..#.#..#..#.#.#.####.###
#..####...#.#.#.###.###.
#####..#####...###....##
#.##..#..#...#..####...#
.#.###..##..##..####.##.
...###...##...#...#..###
Now, you're ready to search for sea monsters! Because your image is monochrome, a sea monster will look like this:

                  # 
#    ##    ##    ###
 #  #  #  #  #  #   
When looking for this pattern in the image, the spaces can be anything; only the # need to match. Also, you might need to rotate or flip your image before it's oriented correctly to find sea monsters. In the above image, after flipping and rotating it to the appropriate orientation, there are two sea monsters (marked with O):

.####...#####..#...###..
#####..#..#.#.####..#.#.
.#.#...#.###...#.##.O#..
#.O.##.OO#.#.OO.##.OOO##
..#O.#O#.O##O..O.#O##.##
...#.#..##.##...#..#..##
#.##.#..#.#..#..##.#.#..
.###.##.....#...###.#...
#.####.#.#....##.#..#.#.
##...#..#....#..#...####
..#.##...###..#.#####..#
....#.##.#.#####....#...
..##.##.###.....#.##..#.
#...#...###..####....##.
.#.##...#.##.#.#.###...#
#.###.#..####...##..#...
#.###...#.##...#.##O###.
.O##.#OO.###OO##..OOO##.
..O#.O..O..O.#O##O##.###
#.#..##.########..#..##.
#.#####..#.#...##..#....
#....##..#.#########..##
#...#.....#..##...###.##
#..###....##.#...##.##.#
Determine how rough the waters are in the sea monsters' habitat by counting the number of # that are not part of a sea monster. In the above example, the habitat's water roughness is 273.

How many # are not part of a sea monster?
=end

require './tile'
require './grid'
require 'set'
require './transformer'

include Transformer

def parse_tiles(input)
  tiles_text = input.split("\n\n")
  tiles_text.map do |tile_text|
    tile = Tile.new(tile_text)
    [tile.id, tile]
  end.to_h
end

def find_similar_borders(tiles)
  identicals = {}
  tiles.each do |current_tile_id, tile|
    tile.borders.each do |current_border, index|
      next if identicals[current_border] # Already calculated for this border

      matching = tiles.select do |other_tile_id, other_tile|
        next true if other_tile_id == current_tile_id
        other_tile.has_border(current_border)
      end.map { |tile_id, other_tile| [tile_id, other_tile.match_border(current_border)] }
      identicals[current_border] = matching
    end
  end
  identicals
end

input = File.read('input.txt')
tiles = parse_tiles(input)

identicals = find_similar_borders(tiles)

common = tiles.map do |tile_id, tile|
  shared_borders = tile.get_all_shared_borders(identicals)
  [tile_id, shared_borders]
end.to_h

corners = common.select { |id, borders_by_position| borders_by_position.values.flatten(1).size == 2 }
puts "Corners: #{corners.keys}"

width = height = Math.sqrt(tiles.size)
grid = Grid.new(height)
first_corner_tile = tiles[corners.first[0]]

first_tile_transformations = [
    [:flip_horizontal],
    [:flip_vertical],
].to_enum

loop do
  grid = Grid.new(height)

  # @type [Tile] current_tile
  current_tile = tiles[corners.first[0]]
  grid.set_tile(current_tile, 0, 0)

  i = 0
  loop do
    neighbour = current_tile.find_possible_neighbours(identicals, :right, grid.used_tile_ids)

    if neighbour == nil
      break
    end

    # @type [Tile]
    next_tile = Marshal.load(Marshal.dump(tiles[neighbour[:id]]))
    position = neighbour[:position]
    # We're "upright", moving to our right
    # Us = | --- A
    #      |     |
    #      | --- B
    #
    case position
      # Their border needs to be on the left like this
      #      A --- |
      #      |     |
      #      B --- |
    when :left
      # Them = A --- |
      #        |     |
      #        B --- |
      #
      # Ideal, no changes needed
    when :right
      # Them = | --- A
      #        |     |
      #        | --- B
      #
      next_tile.flip_vertical
    when :top
      # Them = A --- B
      #        |     |
      #        | --- |
      #
      next_tile.rotate
      next_tile.rotate
      next_tile.rotate
      next_tile.flip_horizontal
    when :bottom
      # Them = | --- |
      #        |     |
      #        A --- B
      #
      next_tile.rotate
    end

    if neighbour[:reversed]
      # Us = | --- A
      #      |     |
      #      | --- B
      #
      # But we had to reverse the border to find a match
      # ie
      # Us = | --- B
      #      |     |
      #      | --- A
      # This means we flipped horizontally.
      # So every match must fit the new position, then flip horizontally to match the original
      next_tile.flip_horizontal
    end

    grid.set_tile(next_tile, 0, i + 1)
    current_tile = next_tile
    break if next_tile.is_corner(corners)

    i += 1
  end

  grid.row(0).each_with_index do |tile, col|
    j = 0
    current_tile = tile
    loop do
      neighbour = current_tile.find_possible_neighbours(identicals, :down, grid.used_tile_ids)
      if neighbour == nil
        # We've reached the opposite edge
        break
      else
        next_tile = Marshal.load(Marshal.dump(tiles[neighbour[:id]]))
        position = neighbour[:position]
        # We're "upright", moving down
        # Us = | --- |
        #      |     |
        #      A --- B
        #
        case position
          # Their border needs to be on the top like this
          #      A --- B
          #      |     |
          #      | --- |
        when :left
          # Them = A --- |
          #        |     |
          #        B --- |
          #
          next_tile.rotate
          next_tile.flip_vertical
        when :right
          # Them = | --- A
          #        |     |
          #        | --- B
          #
          next_tile.rotate
          next_tile.rotate
          next_tile.rotate
        when :top
          # Them = A --- B
          #        |     |
          #        | --- |
          #
          # Ideal
        when :bottom
          # Them = | --- |
          #        |     |
          #        A --- B
          #
          next_tile.flip_horizontal
        end

        if neighbour[:reversed]
          # Us = | --- |
          #      |     |
          #      A --- B
          #
          # But we had to reverse the border to find a match
          # ie
          # Us = | --- |
          #      |     |
          #      B --- A
          # This means we flipped vertically.
          # So every match must fit the new position, then flip vertically to match the original
          next_tile.flip_vertical
        end

        grid.set_tile(next_tile, j + 1, col)
        current_tile = next_tile

        j += 1
      end

    end
  end

  if grid.size == tiles.size
    # We've found a solution
    break
  else
    # Incomplete. Adjust start and try again.
    first = Marshal.load(Marshal.dump(first_corner_tile))
    first_tile_transformations.next.each { |t| first.send(t) }
    tiles[corners.first[0]] = first
  end
end

File.write("tiles.txt", grid.ids)

# Verify that all tiles fit properly
grid.verify

# For eye comparison
File.write("grid.borders.txt", Grid.print_grid(grid.image(with_separator: true, with_borders: true)))
File.write("grid.txt", Grid.print_grid(grid.image(with_separator: true)))

grid_content = grid.image
original_grid_content = Marshal.load(Marshal.dump(grid_content))
File.write("grid2.txt", Grid.print_grid(original_grid_content))

=begin
Pattern:
                #
#    ##    ##    ###
 #  #  #  #  #  #

20 characters long
=end

# Some of these are probably equivalent; I don't care
transformations = [
    [:flip_horizontal],
    [:flip_vertical],
    [:rotate_90],
    [:rotate_90, :flip_vertical],
    [:rotate_90, :flip_horizontal],
    [:rotate_180],
    [:rotate_180, :flip_vertical],
    [:rotate_180, :flip_horizontal],
    [:rotate_270],
    [:rotate_270, :flip_vertical],
    [:rotate_270, :flip_horizontal],
].to_enum
sea_monster_locations = []

loop do
  grid_content.each.with_index do |line, index|

    l2 = grid_content[index + 1]
    l3 = grid_content[index + 2]

    next if l2 == nil || l3 == nil

    possible_starts = (0..grid_content.size - 20)
    possible_starts.each do |i|
      if line[i + 18] == "#" && l2[i] == "#" && l2[i + 5] == "#" && l2[i + 6] == "#" && l2[i + 11] == "#" &&
          l2[i + 12] == "#" && l2[i + 17] == "#" && l2[i + 18] == "#" && l2[i + 19] == "#" && l3[i + 1] == "#" &&
          l3[i + 4] == "#" && l3[i + 7] == "#" && l3[i + 10] == "#" && l3[i + 13] == "#" && l3[i + 16] == "#"

        line[i + 18] = l2[i] = l2[i + 5] = l2[i + 6] = l2[i + 11] = l2[i + 12] = l2[i + 17] = l2[i + 18] =
            l2[i + 19] = l3[i + 1] = l3[i + 4] = l3[i + 7] =
                l3[i + 10] = l3[i + 13] = l3[i + 16] = "D"

        sea_monster_locations << [index, i]
      end
    end

  end

  if sea_monster_locations.size == 0
    transforms = transformations.next
    grid_content = original_grid_content
    transforms.each do |transform|
      grid_content = Transformer.send(transform, grid_content)
    end
  else
    break
  end
end

File.write("grid.monsters.txt", Grid.print_grid(grid_content))

puts "Sea monster locations [line, start index]: #{sea_monster_locations}"
puts "Sea monsters: #{sea_monster_locations.size}"

content = grid_content.flat_map(&:join).join # Convert to simple string
p content.count("#")
