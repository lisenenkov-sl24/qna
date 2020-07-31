Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[create edit update destroy] do
      member do
        post :best
      end
    end
  end
end
