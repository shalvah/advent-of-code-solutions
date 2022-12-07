input = File.read('day_7.txt')

commands_and_outputs = input.each_line.chunk_while { |line1, line2| !line2.start_with?('$') }
  .map do |lines|
  command, *args = lines[0].chomp[2..].split(' ')
  [
    [command, *args],
    lines[1..].map { |dir_item| dir_item.chomp.split(' ') }, # Only present for `ls`
  ]
end

# Stack-ish solution. Maybe also try a state machine?

def get_location(tree, path_parts)
  return tree if path_parts.empty?

  get_location(tree[path_parts[0]], path_parts[1..])
end

pwd = ['']
tree = {}
tree[pwd[0]] = {}

commands_and_outputs.each do |(command_line, output)|
  command, *args = command_line
  if command == 'cd'
    case args[0]
      when '/'
        pwd = ['']
      when '..'
        pwd.pop
      else
        pwd << args[0]
    end
  else
    if command == 'ls'
      next if output.empty?
      output.each do |(type_or_size, name)|
        if type_or_size == 'dir'
          get_location(tree, pwd)[name] = {}
        else
          get_location(tree, pwd)[name] = type_or_size.to_i
        end
      end
    end
  end
end

# pp tree

$sizes = {}

def sum_sizes(tree, prefix = '')
  tree.flat_map do |name, dir_or_file|
    if dir_or_file.is_a? Hash
      $sizes["#{prefix}/#{name}"] = sum_sizes(dir_or_file, name)
    else
      dir_or_file
    end
  end.sum(0)
end

# Part 1
total_size = sum_sizes(tree)
p $sizes.values.filter { |s| s <= 100000 }.sum

# Part 2
TOTAL_SPACE = 70000000
NEEDED_UNUSED = 30000000
total_free = TOTAL_SPACE - total_size
p $sizes.values.filter { |s| total_free + s >= NEEDED_UNUSED }.min
