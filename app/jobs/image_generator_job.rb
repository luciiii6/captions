require './lib/meme/download'
require './lib/meme/image_creator'
class ImageGeneratorJob < ApplicationJob
  queue_as :default

  def perform(caption, images_dir, image_name)
    path = Download.download_image(caption.url, images_dir, image_name)
    ImageCreator.create_meme(path, caption.text)
    true
  end
end
