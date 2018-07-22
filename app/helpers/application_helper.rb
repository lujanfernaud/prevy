# frozen_string_literal: true

module ApplicationHelper
  include Application::HeaderHelpers
  include Application::AlertHelpers

  def home_page?
    controller_name == "home"
  end

  def page_without_footer?
    actions_without_footer.include? [controller_path, action_name]
  end

  def actions_without_footer
    [
      ["users/registrations",       "new"],   # Sign up
      ["users/registrations",    "create"],   # Sign up error
      ["devise/sessions",           "new"],   # Log in
      ["devise/passwords",          "new"],   # Request new password
      ["users/confirmations",       "show"],  # Confirm account
      ["users/confirmations",       "new"],   # Request new confirmation

      ["users/registrations",       "edit"],  # Edit account
      ["users",                     "edit"],  # Edit profile
      ["users/notifications",       "edit"],  # Edit email notifications

      ["users/notifications",       "index"], # User notifications
      ["users",                     "show"],  # Profile
      ["users/memberships",         "index"], # My groups
      ["users/membership_requests", "index"], # Membership requests
      ["users/membership_requests", "show"],  # Membership request

      ["groups/membership_requests", "new"],  # Request membership

      ["groups/members",            "show"],  # Member profile
      ["events/attendees",          "show"],  # Attendee profile
      ["groups/invitations",        "new"],   # Invite someone
      ["groups/invitations",        "index"], # Invitations index

      ["searches",                  "show"],  # Search results

      ["static_pages",              "create_group_unconfirmed"],
      ["static_pages",              "hidden_group"]
    ]
  end

  def breadcrumbs_separator
    "<span class='breadcrumbs-separator'> / </span>"
  end
end
