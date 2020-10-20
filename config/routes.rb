require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  get 'search', to: "search#search"

  concern :rateable do
    member do
      patch :rate_up
      patch :rate_down
      delete :cancel_vote
    end
  end

  concern :commentable do
    post :create_comment, on: :member
  end

  resources :questions, concerns: %i[rateable commentable] do
    resources :answers, shallow: true, concerns: %i[rateable commentable], only: %i[create update destroy] do
      member do
        patch :choose_as_best
      end
    end
    resources :subscriptions, shallow: true, only: %i[create destroy]
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index
  resources :links, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  root to: 'questions#index'
end
