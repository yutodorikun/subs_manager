class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :category
  
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :billing_cycle, inclusion: { in: %w[monthly yearly] }
  validates :start_date, presence: true
  
  scope :active, -> { where(is_active: true) }
  scope :by_category, ->(category) { where(category: category) }
  scope :with_category, -> { includes(:category) }
  scope :with_user, -> { includes(:user) }
  
  def next_payment_date
    case billing_cycle
    when 'monthly'
      calculate_next_monthly_payment
    when 'yearly'
      calculate_next_yearly_payment
    end
  end
  
  def days_until_payment
    (next_payment_date - Date.current).to_i
  end
  
  private
  
  def calculate_next_monthly_payment
    date = start_date
    while date <= Date.current
      date = date.next_month
    end
    date
  end
  
  def calculate_next_yearly_payment
    date = start_date
    while date <= Date.current
      date = date.next_year
    end
    date
  end
end