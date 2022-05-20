class UsersController < ApplicationController
  skip_before_action :authenticate!
  
  def sign_up
    permitted_params = params[:user].permit(:email, :password)
    user = User.create(permitted_params)
    token = user.tokens.create

    response = {
      token: token.value
    }

    render json: response, status: :created
  end
end
