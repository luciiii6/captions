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

  def create
    caption = {
      caption: {
        id: 123,
        url: "http://image.url",
        text: "caption text",
        caption_url: "http://example.com/images/meme.jpb"
      }
    }

    render json: caption, status: :created
  end
end
