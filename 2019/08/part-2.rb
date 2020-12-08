=begin
--- Part Two ---
Now you're ready to decode the image. The image is rendered by stacking the layers and aligning the pixels with the same positions in each layer. The digits indicate the color of the corresponding pixel: 0 is black, 1 is white, and 2 is transparent.

The layers are rendered with the first layer in front and the last layer in back. So, if a given position has a transparent pixel in the first and second layers, a black pixel in the third layer, and a white pixel in the fourth layer, the final image would have a black pixel at that position.

For example, given an image 2 pixels wide and 2 pixels tall, the image data 0222112222120000 corresponds to the following image layers:

Layer 1: 02
         22

Layer 2: 11
         22

Layer 3: 22
         12

Layer 4: 00
         00
Then, the full image can be found by determining the top visible pixel in each position:

The top-left pixel is black because the top layer is 0.
The top-right pixel is white because the top layer is 2 (transparent), but the second layer is 1.
The bottom-left pixel is white because the top two layers are 2, but the third layer is 1.
The bottom-right pixel is black because the only visible pixel in that position is 0 (from layer 4).
So, the final image looks like this:

01
10
What message is produced after decoding your image?
=end

file = File.open("input.txt")
input = file.read

$width = 25
$height = 6

layout = []
# Manually put them into layers (there are probably easier, builtin ways to do this)
current_layer = 0
number_of_pixels = $width * $height
input.each_char.with_index do |char, index|
  wrapped_index = index % number_of_pixels
  current_layer += 1 if index >= number_of_pixels && wrapped_index == 0

  row = (wrapped_index / $width).truncate

  layout[current_layer] ||= []
  layout[current_layer][row] ||= []
  layout[current_layer][row] << char
end

def get_visible_pixel(pixels)
  visible_pixel = pixels.each do |pixel|
    case pixel
    when "0", "1"
      return pixel
    end
  end
  "2"
end

def compute_final_image(layers)
  image = []
  (0...$height).each do |row|
    (0...$width).each do |column|
      pixels = (0...layers.size).map do |layer|
        layers[layer][row][column]
      end
      pixel = get_visible_pixel(pixels)
      image[row] ||= []
      image[row][column] = pixel
    end
  end
  image
end

# This part is hilarious. Copy the output and open in an editor like VS COde,
# with a good font size to see an instantly-legible image
compute_final_image(layout).each do |line|
  rendered = line.map do |char|
    if char == "0"
      "⚫"
    else
      "⚪"
    end
  end
  puts rendered.join
end
