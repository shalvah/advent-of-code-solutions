# Same as the other solution; just different in the rendering part:
# Generates an actual image with Chunky_png

require 'chunky_png'

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
  image = ChunkyPNG::Image.new($width, $height, ChunkyPNG::Color::TRANSPARENT)
  (0...$height).each do |row|
    (0...$width).each do |column|
      pixels = (0...layers.size).map do |layer|
        layers[layer][row][column]
      end
      pixel = get_visible_pixel(pixels)
      colour = if pixel == "0" # Black
                 ChunkyPNG::Color.rgb(0, 0, 0)
               else
                 # White
                 ChunkyPNG::Color.rgb(255, 255, 255)
               end
      image[column, row] = colour
    end
  end
  image.save('password.png', {interlace: true})
end

compute_final_image(layout)
