require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /sign_up" do
    let(:params) do
      {
        user: {
          email: "foo@bar.com",
          password: "test123"
        }
      }
    end

    it "responds with created" do
      post "/users/sign_up", params: params

      expect(response).to have_http_status(:created)
    end

    it "creates a user" do
      expect {
        post "/users/sign_up", params: params
      }.to change { User.count }.by(1)
    end

    it "creates a token" do
      expect {
        post "/users/sign_up", params: params
      }.to change { Token.count }.by(1)

      token = Token.last
      expect(token.value).not_to be_blank
      expect(token.expires_at).to be_within(1.second).of(1.day.from_now)
    end

    it "returns the token value" do
      post "/users/sign_up", params: params

      token = Token.last
      expect(JSON.parse(response.body, symbolize_names: true)[:token]).to eq token.value
    end
  end
end