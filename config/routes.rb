Rails.application.routes.draw do
  devise_for :users

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
  end

  resources :attachments, only: :destroy
  resources :rewards, only: :index
  resources :links, only: :destroy

  root to: 'questions#index'
end
