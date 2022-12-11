$monkey_details = File.read('day_11.txt').split("\n\n").map do |lines|
  lines.split("\n").tap(&:shift).map.with_index do |line, index|
    line.sub(/  Starting items: |  Operation: new = |  Test: divisible by |    If .+: throw to monkey /, '')
      .then do |l|
      if index == 0
        l.split(', ').map(&:to_i)
      elsif index != 1
        l.to_i
      else
        l
      end
    end
  end
end

$monkey_items = $monkey_details.map(&:shift)

def solve(monkey_items, rounds, divisor: nil, modulo: nil)
  inspections = [0] * monkey_items.size

  rounds.times do |round|
    $monkey_details.each_with_index do |monkey, index|
      operation, test, if_true, if_false = monkey
      until monkey_items[index].empty?
        old = monkey_items[index].shift # `old` used in eval below
        new_worry_level = eval(operation)
        new_worry_level /= divisor if divisor
        divisible = new_worry_level % test == 0
        new_worry_level %= modulo if modulo
        (divisible ? monkey_items[if_true] : monkey_items[if_false]) << new_worry_level
        inspections[index] += 1

        # puts "Monkey #{index} inspected item with WL #{old}"
        # puts "  new WL #{new_worry_level},#{divisible ? '' : ' not'} divisible by #{test}"
      end
    end
  end

  p inspections.max(2).reduce(:*)
end

# Part 1
solve($monkey_items.map(&:dup), 20, divisor: 3)
# Part 2
lcm = $monkey_details.map { |l| l[1] }.reduce(&:*)
solve($monkey_items.map(&:dup), 10000, modulo: lcm)
