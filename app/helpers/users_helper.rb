module UsersHelper
  def organized_events_header(events)
    if events.count > 3
      "Organized (last 3)"
    else
      "Organized"
    end
  end

  def edit_profile_link(user)
    if user == current_user
      "(#{link_to "Edit profile",
          edit_user_path(user) + "#edit-profile" })".html_safe
    end
  end
end
