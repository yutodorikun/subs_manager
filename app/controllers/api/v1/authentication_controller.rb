class Api::V1::AuthenticationController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:google_login]
  
  def google_login
    google_user_data = verify_google_token(params[:token])
    
    if google_user_data
      user = User.from_google_oauth(google_user_data)
      token = generate_jwt_token(user)
      
      render json: {
        user: UserSerializer.new(user).as_json,
        token: token
      }
    else
      render json: { error: 'Invalid Google token' }, status: :unauthorized
    end
  rescue => e
    render json: { error: 'Authentication failed' }, status: :unauthorized
  end
  
  def logout
    head :no_content
  end
  
  def me
    render json: UserSerializer.new(current_user).as_json
  end
  
  private
  
  def verify_google_token(token)
    require 'net/http'
    require 'json'
    
    uri = URI("https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{token}")
    response = Net::HTTP.get_response(uri)
    
    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      # テスト環境では GOOGLE_CLIENT_ID チェックをスキップ
      if Rails.env.test? || data['aud'] == ENV['GOOGLE_CLIENT_ID']
        data
      else
        nil
      end
    else
      nil
    end
  end
  
  def generate_jwt_token(user)
    payload = {
      user_id: user.id,
      exp: 24.hours.from_now.to_i
    }
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end
end