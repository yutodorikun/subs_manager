Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # Google OAuth認証
      post '/auth/google', to: 'authentication#google_login'
      delete '/auth/logout', to: 'authentication#logout'
      get '/auth/me', to: 'authentication#me'
      
      # ユーザー
      get '/profile', to: 'users#show'
      patch '/profile', to: 'users#update'
      
      # サブスクリプション
      resources :subscriptions do
        member do
          patch :toggle_active
        end
        collection do
          get :statistics
        end
      end
      
      # カテゴリ
      resources :categories, only: [:index]
      
      # 代替プラン
      resources :alternative_plans, only: [:index] do
        collection do
          get :by_category
        end
      end
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
