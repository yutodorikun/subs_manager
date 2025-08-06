require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase
  def setup
    @user = users(:regular_user)
    @category = categories(:video_streaming)
    @subscription = Subscription.new(
      user: @user,
      category: @category,
      name: "Netflix",
      price: 1490,
      billing_cycle: 'monthly',
      start_date: 1.month.ago,
      payment_method: 'クレジットカード'
    )
  end
  
  test "should be valid with valid attributes" do
    assert @subscription.valid?
  end
  
  test "should require name" do
    @subscription.name = nil
    assert_not @subscription.valid?
    assert_includes @subscription.errors[:name], "can't be blank"
  end
  
  test "should require positive price" do
    @subscription.price = 0
    assert_not @subscription.valid?
    assert_includes @subscription.errors[:price], "must be greater than 0"
    
    @subscription.price = -100
    assert_not @subscription.valid?
  end
  
  test "should belong to user and category" do
    assert_equal @user, @subscription.user
    assert_equal @category, @subscription.category
  end
  
  test "should calculate next payment date for monthly billing" do
    @subscription.save!
    next_payment = @subscription.next_payment_date
    
    # 来月の同じ日付であることを確認
    expected_date = (@subscription.start_date + 1.month).beginning_of_day
    while expected_date <= Date.current
      expected_date += 1.month
    end
    
    assert_equal expected_date.to_date, next_payment
  end
  
  test "should calculate next payment date for yearly billing" do
    @subscription.billing_cycle = 'yearly'
    @subscription.save!
    
    next_payment = @subscription.next_payment_date
    expected_date = (@subscription.start_date + 1.year).beginning_of_day
    while expected_date <= Date.current
      expected_date += 1.year
    end
    
    assert_equal expected_date.to_date, next_payment
  end
  
  test "should calculate days until payment" do
    @subscription.start_date = 5.days.from_now.to_date
    @subscription.save!
    
    assert_equal 5, @subscription.days_until_payment
  end
  
  test "should scope active subscriptions" do
    active_sub = create(:subscription, is_active: true)
    inactive_sub = create(:subscription, is_active: false)
    
    active_subs = Subscription.active
    
    assert_includes active_subs, active_sub
    assert_not_includes active_subs, inactive_sub
  end
end