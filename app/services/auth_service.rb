# frozen_string_literal: true

class AuthService
  SECRET = 'secret'
  ALGORITHM = 'HS256'

  def self.encode(payload, exp)
    payload[:exp] = Time.now.to_i + exp
    JWT.encode payload, SECRET, ALGORITHM
  end

  def self.decode(token)
    (JWT.decode token, SECRET, true, { algorithm: ALGORITHM }).first
  end
end
