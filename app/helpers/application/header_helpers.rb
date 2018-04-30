module Application::HeaderHelpers
  def create_group_menu_link(user)
    if user&.confirmed?
      create_group_link_enabled
    else
      create_group_link_disabled
    end
  end

  def create_group_link_enabled
    link_to "Create group", new_group_path,
      class: "dropdown-item create-group-link"
  end

  def create_group_link_disabled
    link_to "Create group", "",
      class: "dropdown-item  create-group-link disabled",
      title: "You need to activate your account to create your own group.",
      aria: { disabled: "true" }, disabled: true
  end
end
