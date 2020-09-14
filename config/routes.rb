Rails.application.routes.draw do
  devise_for :users

  concern :rateable do
    member do
      patch :rate_up
      patch :rate_down
      delete :cancel_vote
    end
  end

  resources :questions, concerns: %i[rateable] do
    resources :answers, shallow: true, concerns: %i[rateable], only: %i[create update destroy] do
      member do
        patch :choose_as_best
      end
    end
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index
  resources :links, only: :destroy

  root to: 'questions#index'
end
