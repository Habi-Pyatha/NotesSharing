class Api::V1::RegistrationsController < Api::V1::ApplicationController
  skip_before_action :authenticate_user!
  def create
    user=User.new(user_params)
    if user.save
      token = JwtService.encode(user_id: user.id)
      render json: { message: "User successfully registered", token: token, user: user }, status: :created
    else
      render json: { error: user.errors.full_messages.to_json }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.permit(:email, :password, :username, :phone, :user_image)
  end
end
