=begin
--- Day 24: Lobby Layout ---
Your raft makes it to the tropical island; it turns out that the small crab was an excellent navigator. You make your way to the resort.

As you enter the lobby, you discover a small problem: the floor is being renovated. You can't even reach the check-in desk until they've finished installing the new tile floor.

The tiles are all hexagonal; they need to be arranged in a hex grid with a very specific color pattern. Not in the mood to wait, you offer to help figure out the pattern.

The tiles are all white on one side and black on the other. They start with the white side facing up. The lobby is large enough to fit whatever pattern might need to appear there.

A member of the renovation crew gives you a list of the tiles that need to be flipped over (your puzzle input). Each line in the list identifies a single tile that needs to be flipped by giving a series of steps starting from a reference tile in the very center of the room. (Every line starts from the same reference tile.)

Because the tiles are hexagonal, every tile has six neighbors: east, southeast, southwest, west, northwest, and northeast. These directions are given in your list, respectively, as e, se, sw, w, nw, and ne. A tile is identified by a series of these directions with no delimiters; for example, esenee identifies the tile you land on if you start at the reference tile and then move one tile east, one tile southeast, one tile northeast, and one tile east.

Each time a tile is identified, it flips from white to black or from black to white. Tiles might be flipped more than once. For example, a line like esew flips a tile immediately adjacent to the reference tile, and a line like nwwswee flips the reference tile itself.

Here is a larger example:

sesenwnenenewseeswwswswwnenewsewsw
neeenesenwnwwswnenewnwwsewnenwseswesw
seswneswswsenwwnwse
nwnwneseeswswnenewneswwnewseswneseene
swweswneswnenwsewnwneneseenw
eesenwseswswnenwswnwnwsewwnwsene
sewnenenenesenwsewnenwwwse
wenwwweseeeweswwwnwwe
wsweesenenewnwwnwsenewsenwwsesesenwne
neeswseenwwswnwswswnw
nenwswwsewswnenenewsenwsenwnesesenew
enewnwewneswsewnwswenweswnenwsenwsw
sweneswneswneneenwnewenewwneswswnese
swwesenesewenwneswnwwneseswwne
enesenwswwswneneswsenwnewswseenwsese
wnwnesenesenenwwnenwsewesewsesesew
nenewswnwewswnenesenwnesewesw
eneswnwswnwsenenwnwnwwseeswneewsenese
neswnwewnwnwseenwseesewsenwsweewe
wseweeenwnesenwwwswnew
In the above example, 10 tiles are flipped once (to black), and 5 more are flipped twice (to black, then back to white). After all of these instructions have been followed, a total of 10 tiles are black.

Go through the renovation crew's list and determine which tiles they need to flip. After all of the instructions have been followed, how many tiles are left with the black side up?
=end


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
    [(Math.sqrt(3).to_r/2), 1.5]
  when 'nw'
    [-(Math.sqrt(3).to_r/2), 1.5]
  when 'se'
    [(Math.sqrt(3).to_r/2), -1.5]
  when 'sw'
    [-(Math.sqrt(3).to_r/2), -1.5]
  end
end

instructions = File.readlines('input2.txt')
                 .map { |line| parse_directions(line.chomp) }

final_squares = instructions.map do |directions|
  position = [0, 0]
  directions.each do |dir|
    delta = get_delta(dir)
    position[0] += delta[0]
    position[1] += delta[1]
  end
  position
end

tally = final_squares.tally
black_squares = tally.select { |position, count| count % 2 == 1 }
p black_squares.size
