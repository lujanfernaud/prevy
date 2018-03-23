Rails.application.routes.draw do
  root   "static_pages#home"

  get    "signup", to: "users#new"
  post   "signup", to: "users#create"
  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :users do
    get       "groups",             to: "user_memberships#index"
    resources :membership_requests, only: [:index, :show]
    resources :notifications,       only: [:index, :destroy]
    post      "notification_cleaners",   to: "notification_cleaners#create"
    get       "notification_redirecter", to: "notification_redirecters#new"
  end

  resources :sessions, only: [:new, :create, :destroy]
  resource  :search,   only: :show

  resources :events do
    resources :attendances
  end

  resources :groups do
    resources :group_memberships, as: :members,
      only: [:index, :create, :destroy]
    resources :membership_requests,
      only: [:index, :new, :create, :destroy]
    resources :group_organizers, as: :organizers,
      only: [:create, :destroy]
    resources :events
  end
end
