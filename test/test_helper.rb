ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "minitest/reporters"
require "webmock/minitest"

Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
    
    # すべてのテストでトランザクションを使用
    self.use_transactional_tests = true
    
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

class ActionDispatch::IntegrationTest
  def setup
    WebMock.disable_net_connect!(allow_localhost: true)
  end
  
  def teardown
    WebMock.reset!
  end
  
  private
  
  def auth_headers(user = nil)
    user ||= users(:regular_user)
    token = generate_jwt_token(user)
    { 'Authorization' => "Bearer #{token}" }
  end
  
  def generate_jwt_token(user)
    payload = { user_id: user.id, exp: 1.hour.from_now.to_i }
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end
end
