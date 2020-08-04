Rails.application.routes.draw do
  devise_for :users

  root 'questions#index'

  resources :questions do
    member do
      delete :deletefile
    end
    resources :answers, shallow: true, only: %i[create edit update destroy] do
      member do
        post :best
        delete :deletefile
      end
    end
  end
end
