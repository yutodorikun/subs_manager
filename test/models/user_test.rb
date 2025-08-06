require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      name: "Test User New",
      email: "testnew@example.com", 
      google_id: "123456789999"
    )
  end
  
  test "should be valid with valid attributes" do
    assert @user.valid?
  end
  
  test "should require name" do
    @user.name = nil
    assert_not @user.valid?
    assert_includes @user.errors[:name], "can't be blank"
  end
  
  test "should require email" do
    @user.email = nil
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end
  
  test "should require unique email" do
    @user.save!
    
    duplicate_user = User.new(
      name: "Another User",  
      email: @user.email,
      google_id: "987654321"
    )
    
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end
  
  test "should require google_id" do
    @user.google_id = nil
    assert_not @user.valid?
    assert_includes @user.errors[:google_id], "can't be blank"
  end
  
  test "should require unique google_id" do
    @user.save!
    
    duplicate_user = User.new(
      name: "Another User",
      email: "another@example.com",
      google_id: @user.google_id
    )
    
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:google_id], "has already been taken"
  end
  
  test "should create user from google oauth data" do
    auth_data = {
      'sub' => '9999988888',
      'email' => 'newuser@example.com',
      'name' => 'New User',
      'picture' => 'https://example.com/avatar.jpg'
    }
    
    assert_difference('User.count', 1) do
      user = User.from_google_oauth(auth_data)
      assert_equal auth_data['sub'], user.google_id
      assert_equal auth_data['email'], user.email
      assert_equal auth_data['name'], user.name
      assert_equal auth_data['picture'], user.avatar_url
    end
  end
  
  test "should find existing user from google oauth data" do
    @user.save!
    
    auth_data = {
      'sub' => @user.google_id,
      'email' => @user.email,
      'name' => @user.name
    }
    
    assert_no_difference('User.count') do
      user = User.from_google_oauth(auth_data)
      assert_equal @user, user
    end
  end
end