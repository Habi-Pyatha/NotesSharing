class Api::V1::ApplicationController < ApplicationController
  skip_forgery_protection with: :exception
  respond_to :json
  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    decoded = JwtService.decode(token)

    if decoded
      @current_user = User.find_by(id: decoded[:user_id])
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
