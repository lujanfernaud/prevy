# frozen_string_literal: true

Rails.application.routes.draw do
  # Devise
  # ------
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
  # ----
  root "home#index"

  # Static Pages
  # ------------
  #
  # Create Group Unconfirmed Notice Page
  get "create_group_unconfirmed", to: "static_pages#create_group_unconfirmed"
  #
  # Hidden Group Notice Page
  get "hidden_group", to: "static_pages#hidden_group"

  # Users
  # -----
  resources :users, only: [:show, :edit, :update] do
    # User Membership Requests (Sent and Received)
    resources :membership_requests, only: [:index, :show],
      controller: "users/membership_requests"

    # User Groups (My Groups)
    get "groups", to: "users/memberships#index"

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
  # ------
  resources :groups do
    # Group Invitations
    resources :invitations, only: [:index, :new, :create],
      controller: "groups/invitations"

    # Group Invited Members
    resources :invited_members, only: [:create],
      controller: "groups/invited_members"

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

  # Events
  # ------
  resources :events, only: [] do
    # Event Attendances
    resources :attendances, only: [:create, :destroy],
      controller: "events/attendances"

    # Event Attendees
    resources :attendees, only: [:index, :show],
      controller: "events/attendees"
  end

  # Search
  # ------
  resource :search, only: :show
end
