Rails.application.routes.draw do
  # http://guides.rubyonrails.org/routing.html
  resources :answers,       only: [:index, :create]
  resources :surveys,       only: [:index, :new, :create, :show, :update]
  resources :users,         only: [:new, :create, :show, :update, :edit]
  resources :user_sessions, only: [:new, :create, :destroy]
  root controller: :user_sessions, action: :new
end
