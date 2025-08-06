class Api::V1::BaseController < ActionController::API
  before_action :authenticate_user!
  
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :bad_request
  
  private
  
  def authenticate_user!
    token = extract_token_from_header
    
    if token
      begin
        decoded = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
        @current_user = User.find(decoded[0]['user_id'])
      rescue JWT::ExpiredSignature
        render json: { error: 'Token has expired' }, status: :unauthorized
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'User not found' }, status: :unauthorized
      end
    else
      render json: { error: 'No token provided' }, status: :unauthorized
    end
  end
  
  def current_user
    @current_user
  end
  
  def extract_token_from_header
    auth_header = request.headers['Authorization']
    auth_header&.split(' ')&.last if auth_header&.start_with?('Bearer ')
  end
  
  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end
  
  def bad_request
    render json: { error: 'Bad request' }, status: :bad_request
  end
end