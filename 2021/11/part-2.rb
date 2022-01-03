require_relative './models'

energy_levels = File.read(File.join(__dir__, "input.txt")).split("\n").map.with_index do |line, y|
  line.split("").map.with_index { |energy, x| Octopus.new(energy, x, y) }
end
grid = Grid.new(energy_levels)

step = 0

loop do
  step += 1
  flasher = Flasher.new(grid)

  energy_levels.each do |line|
    line.each do |octopus|
      octopus.energy_level += 1
      flasher.flash(octopus) if flasher.can_be_flashed(octopus)
    end
  end

  break if flasher.all_flashed

  flasher.reset
  flasher.number_of_flashes
end

p step