# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Dry::Monads[:result]
  JWT_TTL = 120 # seconds
  JWT_SECRET = Rails.application.credentials.jwt_secret

  def encode_token(payload)
    payload[:exp] = Time.now.to_i + JWT_TTL
    JWT.encode(payload, JWT_SECRET)
  end

  def decode_token
    # Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMjN9.FoW4dUPr9HWzOI8S7Ohpe3hGULZEJhNJeouOX8f1sz8
    auth_header = request.headers['Authorization']

    return Failure(:no_authorization_header) unless auth_header

    token = auth_header.split[1]
    begin
      Success(JWT.decode(token, JWT_SECRET, true, algorithm: 'HS256'))
    rescue JWT::ExpiredSignature
      Failure(:jwt_expired_signature)
    rescue JWT::DecodeError
      Failure(:jwt_decode_error)
    end
  end

  def authorize_user
    decoded_token = decode_token

    if decoded_token.failure?
      @authorize_error = decoded_token.failure
      return
    end

    user_id = decoded_token.value![0]['user_id']
    @user = User.find_by(id: user_id)
  end

  def authorize
    authorize_user
    render json: { message: @authorize_error }, status: :unauthorized if @authorize_error
  end
end


def reverse(array)
  (array.size / 2).times do |i|
    array[i], array[-1 - i] = array[-1 - i], array[i]
  end
  array
end

def my_map(arr)
  return arr unless block_given?
  res = []
  arr.each do |el|
    res << yield(el)
  end
  res
end