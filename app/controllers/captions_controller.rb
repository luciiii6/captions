# frozen_string_literal: true

class CaptionsController < ApplicationController
  def index
    captions = Caption.all
    render json: { captions: }
  end

  def create
    attributes = params.require(:caption).permit(:url, :text)
    caption = Caption.create(attributes)

    render json: { caption: }, status: :created
  end
end
