Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'
  resources :questions, only: [:index, :new, :create, :show] do
    resources :answers, only: [:new, :create]
  end
end
