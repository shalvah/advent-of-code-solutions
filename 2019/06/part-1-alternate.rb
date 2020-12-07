# This solution represents the planets and orbits as a linked list

class Planet
  attr_accessor :orbits, :name

  def initialize(name)
    @name = name
  end
  
  def all_orbits
    parent = self.orbits
    orbits = 0
    while parent != nil # Iterate till we get to COM
      orbits += 1
      parent = parent.orbits
    end
    orbits
  end
end

file = File.open("input.txt")
map_data = file.read.split

# We'll record all planets, so we can iterate over them later and fetch their orbits
planets = {"COM" => Planet.new("COM")}

# Create the planets
map_data.each do |direct_orbit|
  orbitee, orbiter = direct_orbit.split(')')
  planets[orbiter] = Planet.new(orbiter)
end

# Set up the orbits between planets
map_data.each do |direct_orbit|
  orbitee, orbiter = direct_orbit.split(')')
  planets[orbiter].orbits = planets[orbitee]
end

total_orbits = planets.sum { |name, planet| planet.all_orbits }

p total_orbits
