require "jwt"
class JwtService
  HMAC_SECRECT =  Rails.application.credentials.secret_key_base

  def self.encode(payload)
    payload[:exp]=12.hours.from_now.to_i
    JWT.encode(payload, HMAC_SECRECT)
  end

  def self.decode(token)
    body=JWT.decode(token, HMAC_SECRECT)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::DecodeError
      nil
  end
end
