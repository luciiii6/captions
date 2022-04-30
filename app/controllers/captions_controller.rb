# frozen_string_literal: true

class CaptionsController < ApplicationController
  def index
    captions = [
      {
        id: 123,
        url: "http://image.url/meme.jpg",
        text: "caption text",
        caption_url: ""
      }
    ]
    render json: { captions: }
    # head :ok
  end
end
