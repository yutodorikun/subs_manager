class Category < ApplicationRecord
  has_many :subscriptions, dependent: :restrict_with_error
  has_many :alternative_plans, dependent: :destroy
  
  validates :name, presence: true, uniqueness: true
  validates :color, presence: true
end