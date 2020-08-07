Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  concern :votable do
    post 'vote', on: :member
    delete 'vote', on: :member, action: :unvote
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, only: %i[create edit update destroy], concerns: [:votable] do
      member do
        post :best
      end
    end
  end

  resources :rewards, only: [:index]
  resources :files, only: [:destroy]
end
