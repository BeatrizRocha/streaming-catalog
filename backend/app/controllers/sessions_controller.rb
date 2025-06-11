class SessionsController < ApplicationController
  before_action :authenticate_request, except: [:create]

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode({ user_id: user.id })
      render json: {
        token: token,
        user: {
          id: user.id,
          email: user.email,
          name: user.name
        }
      }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    render json: { message: "Logged out successfully" }, status: :ok
  end

  private

  def authenticate_request
    header = request.headers['Authorization']
    return render json: { error: "No authentication token provided" }, status: :unauthorized unless header
    token = header.split(' ').last
    return render json: { error: "No authentication token provided" }, status: :unauthorized if token == "Bearer"
    decoded = JsonWebToken.decode(token)
    return render json: { error: "Invalid authentication token" }, status: :unauthorized unless decoded
  end
end
