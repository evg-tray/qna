require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper

  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'
  resources :questions do
    resources :answers, only: [:create, :update, :destroy] do
      match "/set_best_answer" => "answers#set_best_answer", :via => :post, :as => :set_best_answer
    end
    resources :subscriptions, only: [:create, :destroy], shallow: true
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
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end
end
