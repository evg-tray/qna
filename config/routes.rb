Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'
  resources :questions do
    resources :answers, only: [:create, :update, :destroy] do
      match "/set_best_answer" => "answers#set_best_answer", :via => :post, :as => :set_best_answer
    end
  end
  resources :attachments, only: [:destroy]
  resources :votes, only: [:create, :destroy]
  resources :comments, only: [:create]
  mount ActionCable.server => '/cable'
  match "/register_email" => "omnitokens#register_email", :via => :post
  match "/verify_email" => "omnitokens#verify_email", :via => :get

  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, on: :collection
        get :index
      end
    end
  end
end
