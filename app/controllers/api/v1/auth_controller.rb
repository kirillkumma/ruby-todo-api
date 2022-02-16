# frozen_string_literal: true

class Api::V1::AuthController < ApplicationController
  def register
    user = User.create register_params

    if user.errors.messages.empty?
      token = generate_tokens(user)
      render json: { data: { token: } }, status: :created
    else
      render json: { error: { message: user.errors.messages } },
             status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by! email: login_params[:email]

    if user.authenticate(login_params[:password])
      token = generate_tokens(user)
      render json: { data: { token: } }
    else
      render json: { error: { message: 'Wrong password' } },
             status: :unauthorized
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: { message: "User doesn't exist" } },
           status: :not_found
  end

  def authenticate
    refresh_token = request.cookies['refresh_token']

    if refresh_token
      payload = AuthService.decode(refresh_token)
      user = User.find_by!(id: payload['id'])
      token = generate_tokens(user)
      render json: { data: { token: } }
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

  def logout
    response.delete_cookie :refresh_token
    render status: :no_content
  end

  private

  def register_params
    params.permit(:email, :name, :password)
  end

  def login_params
    params.permit(:email, :password)
  end

  def generate_tokens(user)
    response.set_cookie(:refresh_token, {
                          value: AuthService.encode({ id: user.id },
                                                    86_400 * 30),
                          expires: 30.days.from_now,
                          httponly: true,
                          path: '/',
                          same_site: 'Lax'
                        })
    AuthService.encode({ id: user.id, email: user.email,
                         name: user.name }, 60 * 30)
  end
end
