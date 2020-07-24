Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :questions do
    member do
      post 'createanswer'
    end
    resources :answers, shallow: true
  end
end
