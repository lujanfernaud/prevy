Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "user/registrations" }

  root "static_pages#home"

  resource :search, only: :show

  resources :users, only: [:show, :edit, :update] do
    resources :events,                   only: :index
    get       "groups",                  to: "user_memberships#index"
    resources :membership_requests,      only: [:index, :show]
    resources :notifications,            only: [:index, :destroy]
    get       "notification_settings",   to: "notifications#edit"
    put       "notification_settings",   to: "notifications#update"
    post      "notification_cleaners",   to: "notification_cleaners#create"
    get       "notification_redirecter", to: "notification_redirecters#new"
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

  resources :events do
    resources :attendances
  end
end
