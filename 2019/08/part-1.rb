=begin
--- Day 8: Space Image Format ---
The Elves' spirits are lifted when they realize you have an opportunity to reboot one of their Mars rovers, and so they are curious if you would spend a brief sojourn on Mars. You land your ship near the rover.

When you reach the rover, you discover that it's already in the process of rebooting! It's just waiting for someone to enter a BIOS password. The Elf responsible for the rover takes a picture of the password (your puzzle input) and sends it to you via the Digital Sending Network.

Unfortunately, images sent via the Digital Sending Network aren't encoded with any normal encoding; instead, they're encoded in a special Space Image Format. None of the Elves seem to remember why this is the case. They send you the instructions to decode it.

Images are sent as a series of digits that each represent the color of a single pixel. The digits fill each row of the image left-to-right, then move downward to the next row, filling rows top-to-bottom until every pixel of the image is filled.

Each image actually consists of a series of identically-sized layers that are filled in this way. So, the first digit corresponds to the top-left pixel of the first layer, the second digit corresponds to the pixel to the right of that on the same layer, and so on until the last digit, which corresponds to the bottom-right pixel of the last layer.

For example, given an image 3 pixels wide and 2 pixels tall, the image data 123456789012 corresponds to the following image layers:

Layer 1: 123
         456

Layer 2: 789
         012
The image you received is 25 pixels wide and 6 pixels tall.

To make sure the image wasn't corrupted during transmission, the Elves would like you to find the layer that contains the fewest 0 digits. On that layer, what is the number of 1 digits multiplied by the number of 2 digits?
=end


def digits_count_in_layer(layer, digit)
  digits_count_in_rows = layer.map do |row|
    matching_digits_in_row = row.select { |char| char == digit }
    matching_digits_in_row.size
  end
  digits_count_in_rows.sum
end

file = File.open("input.txt")
input = file.read

width = 25
height = 6

layout = []
# Manually put them into layers (there are probably easier, builtin ways to do this)
current_layer = 0
number_of_pixels = width * height
input.each_char.with_index do |char, index|
  wrapped_index = index % number_of_pixels
  current_layer +=1 if index >= number_of_pixels && wrapped_index == 0

  row = (wrapped_index / width).truncate

  layout[current_layer] ||= []
  layout[current_layer][row] ||= []
  layout[current_layer][row] << char
end

zero_digits = layout.map do |layer|
  digits_count_in_layer(layer, "0")
end

layer_with_fewest_zeros = zero_digits.find_index(zero_digits.min)
number_of_one_digits = digits_count_in_layer(layout[layer_with_fewest_zeros], "1")
number_of_two_digits = digits_count_in_layer(layout[layer_with_fewest_zeros], "2")

p number_of_one_digits * number_of_two_digits
