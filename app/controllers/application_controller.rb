# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def authorize
    token = request.headers['Authorization']

    if token
      token = token.split.last
      payload = AuthService.decode(token)
      @current_user = User.find_by!(id: payload['id'])
    else
      render json: { error: { message: 'Unauthorized' } }, status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: { message: 'Invalid token' } },
           status: :unauthorized
  rescue JWT::ExpiredSignature
    render json: { error: { message: 'Token has expired' } },
           status: :unauthorized
  rescue JWT::DecodeError
    render json: { error: { message: 'Inavlid token' } }, status: :unauthorized
  end
end
