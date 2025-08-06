FactoryBot.define do
  factory :subscription do
    association :user
    association :category
    
    name { Faker::App.name }
    price { Faker::Number.between(from: 100, to: 3000) }
    billing_cycle { ['monthly', 'yearly'].sample }
    start_date { Faker::Date.between(from: 1.year.ago, to: Date.current) }
    payment_method { 'クレジットカード' }
    is_active { true }
    service_url { Faker::Internet.url }
    
    trait :netflix do
      name { 'Netflix' }
      price { 1490 }
      billing_cycle { 'monthly' }
    end
    
    trait :inactive do
      is_active { false }
    end
  end
end