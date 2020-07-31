Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions do
    post :best
    resources :answers, shallow: true, only: %i[create edit update destroy]
  end
end
