module ApiHelper
    def authenticate_request!
      params = {
        user: {
          email: "foo@bar.com",
          password: "test123"
        }
      }
      post "/users/sign_up", params: params
  
      expect(response).to have_http_status :created
    end
  
    def auth_headers
      authenticate_request!
      { 'X-Token' => parsed_body[:token]}
    end
end
  
RSpec.configure do |config|
  config.include ApiHelper, type: :request
end