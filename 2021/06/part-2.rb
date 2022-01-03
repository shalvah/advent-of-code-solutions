fish_states = File.read(File.join(__dir__, "input.txt")).split(",").map(&:to_i)

# Number of fish in each state
timers = fish_states.tally

(256 / 7).times do
  next_week = timers.dup
  timers.each do |timer, count|
    case timer
    when 8, 7
      # Only 7 days in a week, so not enough time to reproduce itself; the fish timer simply decreases
      next_week[timer] -= count
      next_week[timer - 7] = (next_week[timer - 7] || 0) + count
    else
      # When the timer is less than 7, it will have enough time to reproduce itself
      # The new fish will have a timer of +2 days (first cycle)
      next_week[timer + 2] = (next_week[timer + 2] || 0) + count
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
