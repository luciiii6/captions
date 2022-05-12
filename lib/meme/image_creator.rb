# frozen_string_literal: true

require './lib/meme/download'
require 'mini_magick'
class ImageCreator
  class << self
    include MiniMagick

    def create_meme(image_path, text)
      image = MiniMagick::Image.new(image_path)
      image.combine_options do |c|
        c.gravity "center"
        c.font "Helvetica"
        c.fill "White"
        c.pointsize "30"
        c.stroke "Black"
        c.strokewidth "2"
        c.draw "text 0,0 '#{text}'"
      end
      image.write(image_path)
    end
  end
end
