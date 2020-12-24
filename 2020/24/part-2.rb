=begin
--- Part Two ---
The tile floor in the lobby is meant to be a living art exhibit. Every day, the tiles are all flipped according to the following rules:

Any black tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white.
Any white tile with exactly 2 black tiles immediately adjacent to it is flipped to black.
Here, tiles immediately adjacent means the six tiles directly touching the tile in question.

The rules are applied simultaneously to every tile; put another way, it is first determined which tiles need to be flipped, then they are all flipped at the same time.

In the above example, the number of black tiles that are facing up after the given number of days has passed is as follows:

Day 1: 15
Day 2: 12
Day 3: 25
Day 4: 14
Day 5: 23
Day 6: 28
Day 7: 41
Day 8: 37
Day 9: 49
Day 10: 37

Day 20: 132
Day 30: 259
Day 40: 406
Day 50: 566
Day 60: 788
Day 70: 1106
Day 80: 1373
Day 90: 1844
Day 100: 2208
After executing this process a total of 100 times, there would be 2208 black tiles facing up.

How many tiles will be black after 100 days?
=end

# This solution takes over 2 minutes on my input. There's probably an optimisation that can be done somewhere.
def parse_directions(directions)
  parsed = []
  append = ''
  directions.each_char do |char|
    if char == "s" || char == "n"
      append = char
    else
      parsed << append + char
      append = ''
    end
  end
  parsed
end

# Use a regular Cartesian plane, with hexagon side unit 1
# And center hexagon at origin 0, 0
def get_delta(direction)
  case direction
  when 'e'
    [Math.sqrt(3).to_r, 0]
  when 'w'
    [-Math.sqrt(3).to_r, 0]
  when 'ne'
    [(Math.sqrt(3).to_r / 2), 1.5]
  when 'nw'
    [-(Math.sqrt(3).to_r / 2), 1.5]
  when 'se'
    [(Math.sqrt(3).to_r / 2), -1.5]
  when 'sw'
    [-(Math.sqrt(3).to_r / 2), -1.5]
  end
end

def apply_flip_rules(neighbours, flips)
  black_neighbours = neighbours.select { |t, flip| flip % 2 == 1 }.size

  if flips % 2 == 1 # black
    if black_neighbours == 0 || black_neighbours > 2
      flips += 1
    end
  else
    # white
    if black_neighbours == 2
      flips += 1
    end
  end
  flips
end

def get_adjacent_tiles(tile)
  neighbour_directions = ['e', 'w', 'ne', 'nw', 'se', 'sw']
  neighbour_directions.map do |dir|
    position = tile.clone
    delta = get_delta(dir)
    position[0] += delta[0]
    position[1] += delta[1]
    position
  end
end

require 'benchmark'
Benchmark.bm do |x|
  x.report do
    instructions = File.readlines('input2.txt')
                       .map { |line| parse_directions(line.chomp) }

    tiles = instructions.map do |directions|
      position = [0, 0]
      directions.each do |dir|
        delta = get_delta(dir)
        position[0] += delta[0]
        position[1] += delta[1]
      end
      position
    end

    tiles = tiles.tally

    all_neighbours = {}
    100.times do
      tiles_copy = tiles.clone
      # We need to add the neighbours first, so we can properly check them (as the number of relevant tiles expands)
      tiles.each do |tile, flips|
        neighbours = get_adjacent_tiles(tile)
        neighbour_flips = neighbours.map { |n| tiles[n] ? tiles[n] : 0 }
        neighbours = neighbours.zip(neighbour_flips).to_h
        neighbours.each do |t, f|
          tiles_copy[t] = f
          all_neighbours[t] ||= {}
          all_neighbours[t][tile] = flips
        end
        all_neighbours[tile] = neighbours
      end
      tiles = tiles_copy

      current_state = tiles.clone
      current_state.each do |tile, flips|
        neighbours = all_neighbours[tile]

        tiles[tile] = apply_flip_rules(neighbours, flips)
      end
    end

    p tiles.select { |pos, flips| flips % 2 == 1 }.size
  end
end

