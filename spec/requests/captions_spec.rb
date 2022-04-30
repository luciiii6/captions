# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Captions", type: :request do
  describe "GET /captions" do
    it "responds with 200" do
      get "/captions"
      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct body' do
      get '/captions'
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response).to eq({ captions: [
                                    {
                                      id: 123,
                                      url: "http://image.url/meme.jpg",
                                      text: "caption text",
                                      caption_url: ""
                                    }
                                  ] })
    end
  end
end
