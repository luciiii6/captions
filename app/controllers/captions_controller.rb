# frozen_string_literal: true

require './lib/meme/download'
require './lib/meme/image_creator'

class CaptionsController < ApplicationController
  def index
    captions = Caption.all
    render json: { captions: }
  end

  def show
    caption = Caption.find(params[:id])

    render json: { "caption": caption }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    errors = error_not_found(e.message)
    render json: { errors: [errors] }, status: :not_found
  end

  def destroy
    caption = Caption.find(params[:id])

    if caption.destroy
      render status: :ok
    else
      errors = caption.errors.map { |err| error_message_invalid_parameters(err.full_message) }
      render json: { errors: }, status: :internal_server_error
    end
  rescue ActiveRecord::RecordNotFound => e
    errors = error_not_found(e.message)
    render json: { errors: [errors] }, status: :not_found
  end

  def create
    attributes = params.require(:caption).permit(:url, :text)
    attributes.fetch(:url)
    attributes.fetch(:text)

    caption = Caption.create(attributes)
    if caption.valid?
      image_name = "#{Digest::MD5.hexdigest("#{caption.url}#{caption.text}")}.jpg"
      path = Download.download_image(caption.url, images_dir, image_name)
      ImageCreator.create_meme(path, caption.text)
      caption.caption_url = "/images/#{image_name}"
      caption.save
      render json: { caption: }, status: :created if caption.valid?
    else
      errors = caption.errors.map { |err| error_message_invalid_parameters(err.full_message) }
      render json: { errors: }, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing, Download::Error => e
    errors = error_message_invalid_parameters(e.message)
    render json: { errors: [errors] }, status: :bad_request
  end

  private

  def error_message_invalid_parameters(description)
    {
      code: "invalid_parameters",
      title: "Invalid parameters in request body",
      description:
    }
  end

  def error_not_found(description)
    {
      code: "not_found",
      title: "Caption not found",
      description:
    }
  end

  def images_dir
    if ENV["RAILS_ENV"] == "test"
      "spec/images/"
    else
      "images/"
    end
  end
end
