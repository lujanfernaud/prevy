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

  # Root
  root "static_pages#home"

  # Users
  resources :users, only: [:show, :edit, :update] do
    # User Groups (My Groups)
    get "groups", to: "users/memberships#index"

    # User Membership Requests
    resources :membership_requests, only: [:index, :show],
      controller: "users/membership_requests"

    # User Events
    resources :events, only: [:index], controller: "users/events"

    # User Notifications
    resources :notifications, only: [:index, :destroy],
      controller: "users/notifications"

    get  "notification_redirecter", to: "users/notification_redirecters#new"
    get  "notification_settings",   to: "users/notifications#edit"
    put  "notification_settings",   to: "users/notifications#update"
    post "notification_cleaners",   to: "users/notification_cleaners#create"
  end

  # Groups
  resources :groups do
    # Group Members
    resources :memberships, as: :members, path: "members",
      only: [:index, :create, :destroy], controller: "groups/memberships"

    resources :users, as: :members, path: "members",
      only: [:show], controller: "groups/users"

    # Group Roles
    resources :roles, only: [:index, :create, :destroy],
      controller: "groups/roles"

    # Group Membership Requests
    resources :membership_requests, only: [:new, :create, :destroy],
      controller: "groups/membership_requests"

    # Group Events
    resources :events

    # Group Topics
    resources :topics, controller: "groups/topics" do
      resources :comments, controller: "groups/topics/comments", shallow: true
    end
  end

  # Events
  resources :events, only: [] do
    # Event Attendees
    resources :attendances, path: "attendees",
      only: [:index, :create, :destroy], controller: "events/attendances"

    resources :users, as: :attendees, path: "attendees",
      only: [:show], controller: "events/users"
  end

  # Search
  resource :search, only: :show
end
