FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    google_id { Faker::Number.number(digits: 10).to_s }
    avatar_url { Faker::Internet.url }
  end
end