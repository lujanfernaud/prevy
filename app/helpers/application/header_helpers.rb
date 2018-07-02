module Application::HeaderHelpers
  def groups_index?
    controller_name == "groups" && action_name == "index"
  end

  def searches_show?
    controller_name == "searches" && action_name == "show"
  end

  def create_group_menu_link(user)
    if user&.confirmed?
      create_group_link_confirmed_user
    else
      create_group_link_unconfirmed_user
    end
  end

  def create_group_link_confirmed_user
    link_to "Create group", new_group_path,
      class: "dropdown-item create-group-link"
  end

  def create_group_link_unconfirmed_user
    link_to "Create group", create_group_unconfirmed_path,
      class: "dropdown-item create-group-link"
  end
end
