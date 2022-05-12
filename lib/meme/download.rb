# frozen_string_literal: true

require "down"

class Download
  class Error < StandardError
  end

  class << self
    def download_image(url, path, name)
      constructed_path = path + name
      file = Down.download(url, destination: constructed_path)
      constructed_path
    rescue Down::Error => e
      raise Download::Error, "Invalid URL provided"
    end
  end
end
