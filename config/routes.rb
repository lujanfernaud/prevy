Rails.application.routes.draw do
  root   "static_pages#home"

  get    "signup", to: "users#new"
  post   "signup", to: "users#create"
  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :users do
    get "groups", to: "group_memberships#index", as: :groups
  end

  resources :sessions, only: [:new, :create, :destroy]
  resource  :search, only: :show

  resources :events do
    resources :attendances
  end

  resources :groups do
    resources :events
    resources :group_members, as: :members
  end
end
