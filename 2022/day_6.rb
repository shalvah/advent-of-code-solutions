$signal = File.read('day_6.txt').split("")

def first_no_duplicates_index(unique_characters_needed)
  stream_index = $signal.each_cons(unique_characters_needed).with_index do |characters, i|
    break i if characters.uniq.size == unique_characters_needed
  end
  stream_index + unique_characters_needed
end

# Part 1
p first_no_duplicates_index(4)

# Part 2
p first_no_duplicates_index(14)
