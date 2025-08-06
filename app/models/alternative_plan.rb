class AlternativePlan < ApplicationRecord
  belongs_to :category
  
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :plan_type, inclusion: { in: %w[same_company competitor] }
  
  scope :same_company, -> { where(plan_type: 'same_company') }
  scope :competitors, -> { where(plan_type: 'competitor') }
end