Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      resources :attachments, shallow: true, only: :destroy
      member do
        patch :choose_as_best
      end
    end

    resources :attachments, only: :destroy
  end

  root to: 'questions#index'
end
