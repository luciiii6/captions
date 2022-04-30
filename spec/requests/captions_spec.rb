# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Captions", type: :request do
  describe "GET /captions" do
    it "responds with 200" do
      get captions_path
      expect(response).to have_http_status(:ok)
    end

    it 'responds with correct body' do
      get captions_path
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response).to eq({ captions: [] })
    end
  end

  describe "POST /captions" do
    let(:body) do
      {
        "caption": {
          "url": "http://image.url",
          "text": "caption text"
        }
      }
    end

    it 'responds with 201' do
      post captions_path, params: body
      expect(response).to have_http_status(:created)
    end

    it 'responds with correct body' do
      post captions_path, params: body
      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response[:caption]).to match(hash_including({
                                                                url: body[:caption][:url],
                                                                text: body[:caption][:text]
                                                              }))
    end
  end
end
