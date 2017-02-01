Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'
  resources :questions do
    resources :answers, only: [:create, :update, :destroy] do
      match "/set_best_answer" => "answers#set_best_answer", :via => :post, :as => :set_best_answer
    end
  end
  resources :attachments, only: [:destroy]
end
