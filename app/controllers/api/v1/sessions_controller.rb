
module Api
  module V1
  class SessionsController < Api::V1::ApplicationController
    #  skip_before_action :verify_authenticity_token, only: [ :create ]
    skip_before_action :authenticate_user!, only: [ :create, :destroy ]
    def create
      user=User.find_by(email: params[:email])
      if user && user.valid_password?(params[:password])
        token = JwtService.encode(user_id: user.id)
        render json: { message: "SignIn Successfully.", token: token }, status: :ok
      else
        render json: { error: "Invalid credentials" }, status: :unauthorized
      end
    end

    def destroy
      render json: { message: "Logged Out successfully" }, status: :ok
    end

    private
    HMAC_SECRECT =  Rails.application.credentials.secret_key_base

  def gen_encode(payload)
    payload[:exp]=12.hours.from_now.to_i
    JWT.encode(payload, HMAC_SECRECT)
  end
  end
  end
end
