source "https://rubygems.org"

ruby "3.1.6"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.5", ">= 7.1.5.1"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Authentication
gem "jwt"
gem "google-id-token"

# API
gem "rack-cors"
gem "active_model_serializers"

# Performance & Caching
gem "redis", "~> 4.0"
gem "redis-rails"

# Security
gem "rack-attack"
gem "secure_headers"

# Monitoring
gem "lograge"
gem "health_check"

# Background Jobs
gem "sidekiq"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  
  # MiniTest関連
  gem "minitest-rails"
  gem "minitest-reporters"
  gem "minitest-stub_any_instance"
  
  # テストデータ・モック
  gem "factory_bot_rails"
  gem "faker"
  gem "webmock"
  gem "vcr"
  gem "shoulda-matchers"
end

group :development do
  gem "listen", "~> 3.3"
  gem "spring"
  gem "bullet"
  gem "rack-mini-profiler"
end

group :production do
  gem "newrelic_rpm"
  gem "sentry-ruby"
  gem "sentry-rails"
end

