# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# カテゴリの初期データ
categories = [
  { name: '動画配信', color: '#ef4444', icon: 'video' },
  { name: '音楽配信', color: '#10b981', icon: 'music' },
  { name: 'クラウドストレージ', color: '#3b82f6', icon: 'cloud' },
  { name: 'ゲーム', color: '#8b5cf6', icon: 'gamepad' },
  { name: 'その他', color: '#6b7280', icon: 'more' }
]

categories.each do |category_attrs|
  Category.find_or_create_by(name: category_attrs[:name]) do |category|
    category.assign_attributes(category_attrs)
  end
end

# 代替プランの初期データ
video_category = Category.find_by(name: '動画配信')
if video_category
  netflix_plans = [
    { name: 'Netflix ベーシック', price: 790, features: 'SD画質、1台同時視聴', plan_type: 'same_company', company: 'Netflix' },
    { name: 'Netflix スタンダード', price: 1490, features: 'HD画質、2台同時視聴', plan_type: 'same_company', company: 'Netflix' },
    { name: 'Netflix プレミアム', price: 1980, features: '4K画質、4台同時視聴', plan_type: 'same_company', company: 'Netflix' }
  ]
  
  netflix_plans.each do |plan|
    video_category.alternative_plans.find_or_create_by(name: plan[:name]) do |alternative|
      alternative.assign_attributes(plan.merge(billing_cycle: 'monthly'))
    end
  end
  
  # 競合他社プラン
  competitors = [
    { name: 'Amazon Prime Video', price: 500, features: '映画・ドラマ見放題', plan_type: 'competitor', company: 'Amazon' },
    { name: 'Disney+', price: 990, features: 'ディズニー作品見放題', plan_type: 'competitor', company: 'Disney' },
    { name: 'Hulu', price: 1026, features: '国内・海外ドラマ豊富', plan_type: 'competitor', company: 'Hulu' }
  ]
  
  competitors.each do |plan|
    video_category.alternative_plans.find_or_create_by(name: plan[:name]) do |alternative|
      alternative.assign_attributes(plan.merge(billing_cycle: 'monthly'))
    end
  end
end

music_category = Category.find_by(name: '音楽配信')
if music_category
  music_plans = [
    { name: 'Spotify Premium', price: 980, features: '音楽聴き放題、オフライン再生', plan_type: 'same_company', company: 'Spotify' },
    { name: 'Apple Music', price: 980, features: '音楽聴き放題、lossless音質', plan_type: 'competitor', company: 'Apple' },
    { name: 'Amazon Music Unlimited', price: 980, features: '音楽聴き放題、Alexa対応', plan_type: 'competitor', company: 'Amazon' }
  ]
  
  music_plans.each do |plan|
    music_category.alternative_plans.find_or_create_by(name: plan[:name]) do |alternative|
      alternative.assign_attributes(plan.merge(billing_cycle: 'monthly'))
    end
  end
end

puts "Seed data has been created successfully!"
puts "Categories created: #{Category.count}"
puts "Alternative plans created: #{AlternativePlan.count}"
