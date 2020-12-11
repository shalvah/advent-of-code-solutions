=begin
--- Part Two ---
To completely determine whether you have enough adapters, you'll need to figure out how many different ways they can be arranged. Every arrangement needs to connect the charging outlet to your device. The previous rules about when adapters can successfully connect still apply.

The first example above (the one that starts with 16, 10, 15) supports the following arrangements:

(0), 1, 4, 5, 6, 7, 10, 11, 12, 15, 16, 19, (22)
(0), 1, 4, 5, 6, 7, 10, 12, 15, 16, 19, (22)
(0), 1, 4, 5, 7, 10, 11, 12, 15, 16, 19, (22)
(0), 1, 4, 5, 7, 10, 12, 15, 16, 19, (22)
(0), 1, 4, 6, 7, 10, 11, 12, 15, 16, 19, (22)
(0), 1, 4, 6, 7, 10, 12, 15, 16, 19, (22)
(0), 1, 4, 7, 10, 11, 12, 15, 16, 19, (22)
(0), 1, 4, 7, 10, 12, 15, 16, 19, (22)
(The charging outlet and your device's built-in adapter are shown in parentheses.) Given the adapters from the first example, the total number of arrangements that connect the charging outlet to your device is 8.

The second example above (the one that starts with 28, 33, 18) has many arrangements. Here are a few:

(0), 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 17, 18, 19, 20, 23, 24, 25, 28, 31,
32, 33, 34, 35, 38, 39, 42, 45, 46, 47, 48, 49, (52)

(0), 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 17, 18, 19, 20, 23, 24, 25, 28, 31,
32, 33, 34, 35, 38, 39, 42, 45, 46, 47, 49, (52)

(0), 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 17, 18, 19, 20, 23, 24, 25, 28, 31,
32, 33, 34, 35, 38, 39, 42, 45, 46, 48, 49, (52)

(0), 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 17, 18, 19, 20, 23, 24, 25, 28, 31,
32, 33, 34, 35, 38, 39, 42, 45, 46, 49, (52)

(0), 1, 2, 3, 4, 7, 8, 9, 10, 11, 14, 17, 18, 19, 20, 23, 24, 25, 28, 31,
32, 33, 34, 35, 38, 39, 42, 45, 47, 48, 49, (52)

(0), 3, 4, 7, 10, 11, 14, 17, 20, 23, 25, 28, 31, 34, 35, 38, 39, 42, 45,
46, 48, 49, (52)

(0), 3, 4, 7, 10, 11, 14, 17, 20, 23, 25, 28, 31, 34, 35, 38, 39, 42, 45,
46, 49, (52)

(0), 3, 4, 7, 10, 11, 14, 17, 20, 23, 25, 28, 31, 34, 35, 38, 39, 42, 45,
47, 48, 49, (52)

(0), 3, 4, 7, 10, 11, 14, 17, 20, 23, 25, 28, 31, 34, 35, 38, 39, 42, 45,
47, 49, (52)

(0), 3, 4, 7, 10, 11, 14, 17, 20, 23, 25, 28, 31, 34, 35, 38, 39, 42, 45,
48, 49, (52)
In total, this set of adapters can connect the charging outlet to your device in 19208 distinct arrangements.

You glance back down at your bag and try to remember why you brought so many adapters; there must be more than a trillion valid ways to arrange them! Surely, there must be an efficient way to count the arrangements.

What is the total number of distinct ways you can arrange the adapters to connect the charging outlet to your device?
=end

require 'set'
=begin

# Naive solution using a DAG + DFS to find all paths

def build_graph(adapters)
  ratings = Set.new(adapters)

  graph = {}

  ratings.each do |current_rating|
    (1..3).each do |difference|
      next_rating = current_rating + difference

      # Build up our directed graph of nodes and where they can be reached from
      # If graph[A] contains B, then A can be reached from B
      if ratings.include?(next_rating)
        graph[next_rating] ||= []
        graph[next_rating] << current_rating
      end
    end
  end

  graph
end

def count_paths(graph, from, to)
  if from == to
    return 1
  end

  current = from
  paths = 0
  possible_nodes = graph[current] || []

  i = 0
  while i < possible_nodes.size
    following_node = possible_nodes[i]
      paths += count_paths(graph, following_node, to)
    i += 1
  end

  paths
end

file = File.open("input.txt")
input = file.read.split
adapters = input.map(&:to_i).sort
adapters = adapters.sort
adapters.unshift(0)
adapters.push(adapters.last + 3)
graph = build_graph(adapters)
p count_paths(graph, adapters.last, adapters.first)
=end

def compute_intervals(adapters)
  remaining_adapters = Set.new(adapters)

  intervals = []
  adapters.each do |current_rating|
    (1..3).each do |difference|
      next_rating = current_rating + difference
      if remaining_adapters.include?(next_rating)
        remaining_adapters.delete(next_rating)
        intervals << difference
        break
      end
    end
  end

  intervals
end

def find_paths(intervals)
  sums = []
  intervals.each_with_index do |current_interval, index|
    # There's only one path from the first node to the root
    if index == 0
      sums << 1
      next
    end

    previous_interval = intervals[index - 1]

    if index == 1
      # For node 2, there can be either 1 or two paths from root
      previous_previous_interval = 9
      if current_interval == 3 ||
          (current_interval == 2 && previous_interval >= 2) ||
          (current_interval == 1 && previous_interval == 3)
        # There's only one path to this one, so it's the same number of paths from root to this node as from root to that node
        sums << 1
      elsif (current_interval == 1 && previous_interval == 1) ||
          (current_interval == 1 && previous_interval == 2) ||
          (current_interval == 2 && previous_interval == 1)
        # Only two paths to here
        sums << 2
      end
      next
    end

    previous_previous_interval = intervals[index - 2]
    if current_interval == 3 ||
        (current_interval == 2 && previous_interval >= 2) ||
        (current_interval == 1 && previous_interval == 3)
      # There's only one path to this one, so it's the same number of paths from root to this node as from root to that node
      sums << sums.last
    elsif current_interval == 1 && previous_interval == 1 && previous_previous_interval == 1
      # Three paths to here
      sums << (sums[-1] + sums[-2] + (sums[-3] || 1))
    elsif (current_interval == 1 && previous_interval == 1 && previous_previous_interval > 1) ||
        (current_interval == 1 && previous_interval == 2) ||
        (current_interval == 2 && previous_interval == 1)
      # Only two paths to here
      sums << (sums[-1] + sums[-2])
    end
  end

  sums
end

file = File.open("input.txt")
input = file.read.split
adapters = input.map(&:to_i).sort
adapters = adapters.sort
adapters.unshift(0)
adapters.push(adapters.last + 3)
intervals = compute_intervals(adapters)
p find_paths(intervals).last
