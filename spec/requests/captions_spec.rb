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
    subject(:post_captions) { post captions_path, params: }

    context "with valid request body" do
      let(:url) { Faker::CryptoCoin.url_logo }
      let(:text) { Faker::CryptoCoin.coin_name }
      let(:caption_url) { "/images/#{Digest::MD5.hexdigest("#{url}#{text}")}.jpg" }
      let(:params) do
        {
          caption: {
            url:,
            text:
          }
        }
      end

      it 'responds with 201' do
        post_captions
        expect(response).to have_http_status(:accepted)
      end

      it 'responds with correct body' do
        post_captions
        json_response = JSON.parse(response.body, symbolize_names: true)

        expect(json_response[:caption]).to match(hash_including({
                                                                  url: params[:caption][:url],
                                                                  text: params[:caption][:text]
                                                                }))
      end
    end

    context "with missing root element caption in request body" do
      let(:params) { {} }

      it "returns 400" do
        post_captions

        expect(response).to have_http_status(:bad_request)
      end

      it "returns an error body with caption invalid parameters message" do
        post_captions

        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:errors].first).to match(hash_including({
                                                                       code: "invalid_parameters",
                                                                       title: "Invalid parameters in request body",
                                                                       description: "param is missing or the value is empty: caption\nDid you mean?  action"
                                                                     }))
      end
    end

    context "with missing url element in request body" do
      let(:params) do
        {
          caption: {
            text: Faker::CryptoCoin.coin_name
          }
        }
      end

      it "returns 400" do
        post_captions

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error body with url invalid parameters message" do
        post_captions

        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:errors].first).to match(hash_including({
                                                                       code: "invalid_parameters",
                                                                       title: "Invalid parameters in request body",
                                                                       description: "Url can't be blank"
                                                                     }))
      end
    end

    context "with missing text element in request body" do
      let(:params) do
        {
          caption: {
            url: Faker::CryptoCoin.url_logo
          }
        }
      end

      it "returns 400" do
        post_captions

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "returns an error body with text invalid parameters message" do
        post_captions

        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:errors].first).to match(hash_including({
                                                                       code: "invalid_parameters",
                                                                       title: "Invalid parameters in request body",
                                                                       description: "Text can't be blank"
                                                                     }))
      end
    end

    context "with invalid url value" do
      let(:params) do
        {
          caption: {
            url:,
            text:
          }
        }
      end

      context "with empty url" do
        let(:url) { "" }
        let(:text) { Faker::CryptoCoin.coin_name }

        it "returns 422" do
          post_captions

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid url value" do
          post_captions

          response_json = JSON.parse(response.body, symbolize_names: true)

          expect(response_json[:errors].first).to match(hash_including({
                                                                         code: "invalid_parameters",
                                                                         title: "Invalid parameters in request body",
                                                                         description: "Url can't be blank"
                                                                       }))
        end
      end
    end

    context "with invalid text value" do
      let(:params) do
        {
          caption: {
            url:,
            text:
          }
        }
      end

      context "with empty text" do
        let(:url) { Faker::CryptoCoin.url_logo }
        let(:text) { "" }

        it "returns 422" do
          post_captions

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid text value" do
          post_captions

          response_json = JSON.parse(response.body, symbolize_names: true)

          expect(response_json[:errors].first).to match(hash_including({
                                                                         code: "invalid_parameters",
                                                                         title: "Invalid parameters in request body",
                                                                         description: "Text can't be blank"
                                                                       }))
        end
      end

      context "with text url" do
        let(:url) { Faker::CryptoCoin.url_logo }
        let(:text) { nil }

        it "returns 422" do
          post_captions

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid text value" do
          post_captions

          response_json = JSON.parse(response.body, symbolize_names: true)

          expect(response_json[:errors].first).to match(hash_including({
                                                                         code: "invalid_parameters",
                                                                         title: "Invalid parameters in request body",
                                                                         description: "Text can't be blank"
                                                                       }))
        end
      end

      context "with text too long" do
        let(:url) { Faker::CryptoCoin.url_logo }
        let(:text) { Faker::String.random(length: 300) }

        it "returns 422" do
          post_captions

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns an error body with invalid text value" do
          post_captions

          response_json = JSON.parse(response.body, symbolize_names: true)

          expect(response_json[:errors].first).to match(hash_including({
                                                                         code: "invalid_parameters",
                                                                         title: "Invalid parameters in request body",
                                                                         description: "Text is too long (maximum is 266 characters)"
                                                                       }))
        end
      end
    end
  end

  describe "DELETE /captions" do
    context "with existing caption" do
      it "returns 200" do
        post captions_path, params: {
          caption: {
            url: Faker::CryptoCoin.url_logo,
            text: Faker::CryptoCoin.coin_name
          }
        }

        id = JSON.parse(response.body, symbolize_names: true)[:caption][:id]

        delete "/captions/#{id}"

        expect(response).to have_http_status(:ok)
      end
    end

    context "with not existing caption" do
      let(:id) { Faker::Number.number }

      before do
        get captions_path

        expect(JSON.parse(response.body, symbolize_names: true)[:captions].length).to eq 0
      end

      it "returns 404" do
        delete "/captions/#{id}"

        expect(response).to have_http_status(:not_found)
      end

      it "returns an error body with caption not found message" do
        delete "/captions/#{id}"

        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:errors].first).to match(hash_including({
                                                                       code: "not_found",
                                                                       title: "Caption not found",
                                                                       description: "Couldn't find Caption with 'id'=#{id}"
                                                                     }))
      end
    end
  end

  describe "GET /captions/:id" do
    context "with existing caption" do
      let(:url) { Faker::CryptoCoin.url_logo }
      let(:text) { Faker::CryptoCoin.coin_name }
      let(:caption_url) { "/images/#{Digest::MD5.hexdigest("#{url}#{text}")}.jpg" }
      let(:params) do
        {
          caption: {
            url:,
            text:
          }
        }
      end

      it "returns 200 and specifed caption as JSON" do
        post captions_path, params: params
        expect(response).to have_http_status(:accepted)

        id = JSON.parse(response.body, symbolize_names: true)[:caption][:id]

        get "/captions/#{id}"
        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(response_json[:caption][:caption_url]).to eq('spec' + caption_url)
      end
    end

    context "with not existing caption" do
      let(:id) { Faker::Number.number }

      before do
        get captions_path

        expect(JSON.parse(response.body, symbolize_names: true)[:captions].length).to eq 0
      end

      it "returns 404" do
        get "/captions/#{id}"

        expect(response).to have_http_status(:not_found)
      end

      it "returns an error body with caption not found message" do
        get "/captions/#{id}"

        response_json = JSON.parse(response.body, symbolize_names: true)

        expect(response_json[:errors].first).to match(hash_including({
                                                                       code: "not_found",
                                                                       title: "Caption not found",
                                                                       description: "Couldn't find Caption with 'id'=#{id}"
                                                                     }))
      end
    end
  end
end
