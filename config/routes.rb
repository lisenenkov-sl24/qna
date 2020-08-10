Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root 'questions#index'

  concern :votable do
    post 'vote', on: :member
    delete 'vote', on: :member, action: :unvote
  end

  resources :questions, concerns: [:votable] do
    resources :comments, only: %i[create]
    resources :answers, shallow: true, only: %i[create edit update destroy], concerns: [:votable] do
      member do
        post :best
      end
      resources :comments, only: %i[create]
    end
  end

  resources :rewards, only: [:index]
  resources :files, only: [:destroy]

  mount ActionCable.server => '/cable'
end
