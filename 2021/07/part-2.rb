positions = File.read(File.join(__dir__, "input.txt")).split(",").map(&:to_i)
mapped = positions.tally

# I sorta "intuitively" felt the alignment would be around the mean...it is🤷‍♂️
mean = (positions.sum.to_f/positions.size)

def cost(mapped, alignment)
  fuel = 0
  mapped.each do |pos, freq|
    n = (pos - alignment).abs
    distance = (n * (n + 1))/2 # Sum of first n numbers
    fuel += distance * freq
  end
  fuel
end

cheapest_cost = [mean.floor, mean.ceil].map do |possible_alignment|
  cost(mapped, possible_alignment)
end.min

p cheapest_cost


