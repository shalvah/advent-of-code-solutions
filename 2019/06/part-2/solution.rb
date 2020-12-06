=begin
--- Part Two ---
Now, you just need to figure out how many orbital transfers you (YOU) need to take to get to Santa (SAN).

You start at the object YOU are orbiting; your destination is the object SAN is orbiting. An orbital transfer lets you move from any object to an object orbiting or orbited by that object.

For example, suppose you have the following map:

COM)B
B)C
C)D
D)E
E)F
B)G
G)H
D)I
E)J
J)K
K)L
K)YOU
I)SAN
Visually, the above map of orbits looks like this:

                          YOU
                         /
        G - H       J - K - L
       /           /
COM - B - C - D - E - F
               \
                I - SAN
In this example, YOU are in orbit around K, and SAN is in orbit around I. To move from K to I, a minimum of 4 orbital transfers are required:

K to J
J to E
E to D
D to I
Afterward, the map of orbits looks like this:

        G - H       J - K - L
       /           /
COM - B - C - D - E - F
               \
                I - SAN
                 \
                  YOU
What is the minimum number of orbital transfers required to move from the object YOU are orbiting to the object SAN is orbiting? (Between the objects they are orbiting - not between YOU and SAN.)
=end

file = File.open("input.txt")
map_data = file.read.split

$orbited_by = {"COM" => []}
$orbiting = {"COM" => nil}
map_data.each do |direct_orbit|
  orbitee, orbiter = direct_orbit.split(')')
  $orbited_by[orbitee] ||= []
  $orbited_by[orbitee] << orbiter
  $orbiting[orbiter] = orbitee
end

# Generate the path from a node to the root (usually "COM"), by only following the node's orbits
def generate_path(node, root = "COM")
  path = []
  at = $orbiting[node]

  while at != root
    path << at
    at = $orbiting[at]
  end
  path
end

def compute_transfers(start_at, end_at)
  path_a = generate_path(start_at)
  path_b = generate_path(end_at)
  intersections = path_a & path_b

  closest = intersections.first
  # Compute the full path and return the number of transfers
  # [*generate_path(start_at, closest), closest, *generate_path(end_at, closest).reverse].size - 1
  # Or, simpler, use the indexes of the intersection
  path_a.find_index(closest) + path_b.find_index(closest)
end

p compute_transfers("YOU", "SAN")
