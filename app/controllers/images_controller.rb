# frozen_string_literal: true

class ImagesController < ApplicationController
  def show
    image_name = "#{params[:id]}.#{params[:format]}"
    send_file Rails.root.join("#{images_dir}#{image_name}"), type: "image/jpeg"
  rescue ActionController::MissingFile
    render json: { errors: [error_not_found(image_name)] }, status: :not_found
  end

  private

  def images_dir
    if ENV["RAILS_ENV"] == "test"
      "spec/images/"
    else
      "images/"
    end
  end

  def error_not_found(image_name)
    {
      code: "not_found",
      title: "Image not found",
      description: "Couldn't find Image #{image_name}"
    }
  end
end
