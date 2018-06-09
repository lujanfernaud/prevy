Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      registrations: "users/registrations",
      confirmations: "users/confirmations"
    }

  devise_scope :user do
    patch "confirm" => "users/confirmations#confirm"
    get   "login"   => "devise/sessions#new"
    get   "logout"  => "devise/sessions#destroy"
  end

  root "static_pages#home"

  resources :users, only: [:show, :edit, :update] do
    resources :events,              only: [:index],
      controller: "users/events"
    resources :membership_requests, only: [:index, :show],
      controller: "users/membership_requests"
    resources :notifications,       only: [:index, :destroy],
      controller: "users/notifications"

    get  "groups",                  to: "users/memberships#index"
    get  "notification_redirecter", to: "users/notification_redirecters#new"
    get  "notification_settings",   to: "users/notifications#edit"
    put  "notification_settings",   to: "users/notifications#update"
    post "notification_cleaners",   to: "users/notification_cleaners#create"
  end

  resources :groups do
    resources :memberships, as: :members, only: [:index, :create, :destroy],
      controller: "groups/memberships"
    resources :membership_requests,       only: [:new, :create, :destroy],
      controller: "groups/membership_requests"
    resources :roles,                     only: [:index, :create, :destroy],
      controller: "groups/roles"
    resources :events

    resources :topics, controller: "groups/topics" do
      resources :comments, controller: "groups/topics/comments", shallow: true
    end
  end

  resources :events do
    resources :attendances, controller: "events/attendances"
  end

  resource :search, only: :show
end
