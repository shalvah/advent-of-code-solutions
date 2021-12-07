fish = File.read(File.join(__dir__, "input.txt")).split(",").map(&:to_i)

timers = fish.tally

(256 / 7).times do
  next_week = timers.dup
  timers.each do |timer, count|
    case timer
    when 8, 7
      next_week[timer] -= count
      next_week[timer - 7] ||= 0
      next_week[timer - 7] += count
    else
      next_week[timer + 2] ||= 0
      next_week[timer + 2] += count
    end
  end
  timers = next_week
end

remaining_days = (256 % 7)
timers.each do |timer, count|
  if timer < remaining_days # Enough time to reproduce!
    timers[timer] += count
  end
end

p timers.values.sum
