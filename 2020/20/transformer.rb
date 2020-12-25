# Transform an array of arrays of strings representing rows and columns
module Transformer
  def rotate_90(contents)
    contents.transpose.map(&:reverse)
  end

  def rotate_180(contents)
    contents.reverse.map(&:reverse)
  end

  def rotate_270(contents)
    contents.transpose.reverse
  end

  def flip_horizontal(contents)
    contents.reverse
  end

  def flip_vertical(contents)
    contents.map(&:reverse)
  end
end
