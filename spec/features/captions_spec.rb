# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Captions", type: :request do
  describe "when creating a caption" do
    let(:url) { Faker::Internet.url }
    let(:text) { Faker::TvShows::GameOfThrones.quote }

    context "when requesting all captions" do
      it "contains the previously created caption" do
        params = {
          caption: {
            url:,
            text:
          }
        }
        post captions_path, params: params
        get captions_path

        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:captions].first).to match(hash_including({
                                                                         url:,
                                                                         text:
                                                                       }))
      end
    end
  end
end
