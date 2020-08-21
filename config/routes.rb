Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    require 'sidekiq/web'
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
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
    resources :subscriptions, only: %i[create destroy], path: 'subscribe'
  end

  resources :search, only: %i[index create]

  resources :rewards, only: [:index]
  resources :files, only: [:destroy]

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :profiles, only: [] do
        collection do
          get :me
          get :notme
        end
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy], shallow: true
      end
    end
  end

  mount ActionCable.server => '/cable'
end
