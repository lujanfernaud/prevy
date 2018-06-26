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

  # ----
  # Root
  root "static_pages#home"

  # -----
  # Users
  resources :users, only: [:show, :edit, :update] do
    # User Groups (My Groups)
    get "groups", to: "users/memberships#index"

    # User Membership Requests (Sent and Received)
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

  # ------
  # Groups
  resources :groups do
    # Group Membership Requests
    resources :membership_requests, only: [:new, :create, :destroy],
      controller: "groups/membership_requests"

    # Group Memberships
    resources :memberships, only: [:create, :destroy],
      controller: "groups/memberships"

    # Group Members
    resources :members, only: [:index, :show],
      controller: "groups/members"

    # Group Roles
    resources :roles, only: [:index, :create, :destroy],
      controller: "groups/roles"

    # Group Events
    resources :events

    # Group Topics
    resources :topics, controller: "groups/topics" do
      resources :comments, controller: "groups/topics/comments", shallow: true
    end
  end

  # ------
  # Events
  resources :events, only: [] do
    # Event Attendances
    resources :attendances, path: "attendees",
      only: [:index, :create, :destroy], controller: "events/attendances"

    # Event Attendees
    resources :attendees, only: [:show], controller: "events/attendees"
  end

  # ------
  # Search
  resource :search, only: :show
end
