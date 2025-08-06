require 'test_helper'

class Api::V1::SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:regular_user)
    @subscription = subscriptions(:netflix)
    @category = categories(:video_streaming)
  end
  
  test "should get index with authentication" do
    get api_v1_subscriptions_url, headers: auth_headers(@user)
    
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal @user.subscriptions.count, json_response.length
    
    # レスポンス構造の確認
    subscription_data = json_response.first
    assert_includes subscription_data.keys, 'id'
    assert_includes subscription_data.keys, 'name'
    assert_includes subscription_data.keys, 'price'
    assert_includes subscription_data.keys, 'category'
  end
  
  test "should require authentication for index" do
    get api_v1_subscriptions_url
    
    assert_response :unauthorized
  end
  
  test "should create subscription with valid params" do
    subscription_params = {
      subscription: {
        name: "Spotify Premium",
        price: 980,
        billing_cycle: 'monthly',
        category_id: @category.id,
        start_date: Date.current,
        payment_method: 'クレジットカード'
      }
    }
    
    assert_difference('@user.subscriptions.count', 1) do
      post api_v1_subscriptions_url,
           params: subscription_params,
           headers: auth_headers(@user),
           as: :json
    end
    
    assert_response :created
    
    json_response = JSON.parse(response.body)
    assert_equal "Spotify Premium", json_response['name']
    assert_equal "980.0", json_response['price']
  end
  
  test "should not create subscription with invalid params" do
    subscription_params = {
      subscription: {
        name: "",
        price: -100,
        billing_cycle: 'monthly',
        category_id: @category.id
      }
    }
    
    assert_no_difference('@user.subscriptions.count') do
      post api_v1_subscriptions_url,
           params: subscription_params,
           headers: auth_headers(@user),
           as: :json
    end
    
    assert_response :unprocessable_entity
    
    json_response = JSON.parse(response.body)
    assert json_response['errors'].present?
  end
  
  test "should update subscription" do
    patch api_v1_subscription_url(@subscription),
          params: { subscription: { name: "Updated Netflix" } },
          headers: auth_headers(@user),
          as: :json
    
    assert_response :success
    
    @subscription.reload
    assert_equal "Updated Netflix", @subscription.name
  end
  
  test "should delete subscription" do
    assert_difference('@user.subscriptions.count', -1) do
      delete api_v1_subscription_url(@subscription),
             headers: auth_headers(@user)
    end
    
    assert_response :no_content
  end
  
  test "should get statistics" do
    get statistics_api_v1_subscriptions_url, headers: auth_headers(@user)
    
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_includes json_response.keys, 'total_monthly_cost'
    assert_includes json_response.keys, 'total_services'
    assert_includes json_response.keys, 'by_category'
  end
  
  test "should toggle subscription active status" do
    original_status = @subscription.is_active
    
    patch toggle_active_api_v1_subscription_url(@subscription),
          headers: auth_headers(@user)
    
    assert_response :success
    
    @subscription.reload
    assert_equal !original_status, @subscription.is_active
  end
end