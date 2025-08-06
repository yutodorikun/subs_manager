FactoryBot.define do
  factory :category do
    name { Faker::App.name }
    color { Faker::Color.hex_color }
    icon { 'video' }
    
    trait :video_streaming do
      name { '動画配信' }
      color { '#ef4444' }
      icon { 'video' }
    end
    
    trait :music_streaming do
      name { '音楽配信' }
      color { '#10b981' }
      icon { 'music' }
    end
  end
end