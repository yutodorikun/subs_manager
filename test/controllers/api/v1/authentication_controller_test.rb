require 'test_helper'

class Api::V1::AuthenticationControllerTest < ActionDispatch::IntegrationTest
  def setup
    # Google認証のモックレスポンス
    @valid_google_response = {
      'sub' => '123456789',
      'email' => 'test@example.com',
      'name' => 'Test User',
      'picture' => 'https://example.com/avatar.jpg',
      'aud' => ENV['GOOGLE_CLIENT_ID'] || 'test_client_id'
    }
  end
  
  test "should login with valid Google token" do
    # Google API呼び出しをモック
    stub_google_token_verification(@valid_google_response)
    
    post api_v1_auth_google_url,
         params: { token: 'valid_google_token' },
         as: :json
    
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_includes json_response.keys, 'user'
    assert_includes json_response.keys, 'token'
    
    # ユーザーが作成または見つかったことを確認  
    user = User.find_by(google_id: @valid_google_response['sub'])
    assert user.present?
    # 既存のフィクスチャユーザーが見つかった場合はそのデータを使用
    assert user.email.present?
    assert user.name.present?
  end
  
  test "should not login with invalid Google token" do
    # 無効なトークンのモック
    stub_request(:get, /googleapis\.com.*tokeninfo/)
      .to_return(status: 400, body: '{"error": "invalid_token"}')
    
    post api_v1_auth_google_url,
         params: { token: 'invalid_google_token' },
         as: :json
    
    assert_response :unauthorized
    
    json_response = JSON.parse(response.body)
    assert_equal 'Invalid Google token', json_response['error']
  end
  
  test "should return current user info" do
    user = users(:regular_user)
    
    get api_v1_auth_me_url, headers: auth_headers(user)
    
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal user.id, json_response['id']
    assert_equal user.email, json_response['email']
  end
  
  private
  
  def stub_google_token_verification(response_data)
    stub_request(:get, /googleapis\.com.*tokeninfo/)
      .to_return(
        status: 200,
        body: response_data.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end
end