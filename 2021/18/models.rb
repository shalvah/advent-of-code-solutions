class SnailfishNumber
  attr_accessor :depth, :index, :parent

  def initialize(depth, index = nil, parent = nil)
    @depth = depth
    @index = index
    @parent = parent
  end

  def self.sum(*numbers)
    numbers.reduce do |prev_sum, number|
      self.parse([prev_sum, number]).reduce
    end
  end

  def self.parse(number_array, depth = 0, index = nil, parent = nil)
    pair = Pair.new(depth, index, parent)
    pair.children = number_array.map.with_index do |element, element_index|
      if element.is_a?(Array)
        SnailfishNumber.parse(element, depth + 1, element_index, pair)
      elsif element.is_a?(Pair)
        SnailfishNumber.parse(element.children, depth + 1, element_index, pair)
      elsif element.is_a?(RegularNumber)
        RegularNumber.new(element.value, depth + 1, element_index, pair)
      else
        RegularNumber.new(element, depth + 1, element_index, pair)
      end
    end

    pair.compute_descendants
    pair
  end
end

class Pair < SnailfishNumber
  attr_accessor :children, :descendants

  def initialize(depth, index = nil, parent = nil)
    super(depth, index, parent)
    @children = []
    @descendants = []
  end

  def reduce
    applied = nil
    until applied === false
      applied = false
      # If any pair is nested inside four pairs, the leftmost such pair explodes
      index_4p = descendants.find_index { |d| d.is_a?(Pair) && d.depth === 4 }
      if index_4p
        applied = true
        inside_four_pairs = descendants[index_4p]

        zero = RegularNumber.new(0, 4, inside_four_pairs.index, inside_four_pairs.parent)
        number_before = descendants[0...index_4p].reverse.find { |d| d.is_a?(RegularNumber) && !inside_four_pairs.children.include?(d) }
        if number_before
          number_before.value += inside_four_pairs.children[0].value
        end
        number_after = descendants[index_4p..-1].find { |d| d.is_a?(RegularNumber) && !inside_four_pairs.children.include?(d) }
        if number_after
          number_after.value += inside_four_pairs.children[1].value
        end

        inside_four_pairs.parent.children[inside_four_pairs.index] = zero
        Pair.update_descendants_up_to_top(inside_four_pairs)
      else
        # If any regular number is 10 or greater, the leftmost such regular number splits.
        index_gte10 = descendants.find_index { |d| d.is_a?(RegularNumber) && d.value >= 10 }

        if index_gte10
          applied = true
          number_to_split = descendants[index_gte10]
          new_pair = Pair.new(number_to_split.depth, number_to_split.index, number_to_split.parent)
          left = RegularNumber.new((number_to_split.value / 2.0).floor, new_pair.depth + 1, 0, new_pair)
          right = RegularNumber.new((number_to_split.value / 2.0).ceil, new_pair.depth + 1, 1, new_pair)
          new_pair.children = [left, right]
          new_pair.parent.children[number_to_split.index] = new_pair
          new_pair.compute_descendants
          Pair.update_descendants_up_to_top(new_pair)
        end
      end
    end

    self
  end

  def compute_descendants
    @descendants = []
    children.each do |element|
      @descendants << element
      if element.is_a?(Pair)
        @descendants = @descendants.concat(element.descendants)
      end
    end
  end

  def self.update_descendants_up_to_top(element)
    parent = element.parent
    while parent
      parent.compute_descendants
      parent = parent.parent
    end
  end

  def magnitude
    (3 * children[0].magnitude) + (2 * children[1].magnitude)
  end

  def inspect
    "[ #{@children[0].inspect} , #{@children[1].inspect} ]"
  end
end

class RegularNumber < SnailfishNumber
  attr_accessor :value

  def initialize(value, depth, index, parent)
    super(depth, index, parent)
    @value = value
  end

  def magnitude
    @value
  end

  def inspect
    @value
  end
end
