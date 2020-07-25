Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions do
    member do
      post 'createanswer'
    end
    resources :answers, shallow: true
  end
end
