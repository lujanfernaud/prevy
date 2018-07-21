# frozen_string_literal: true

module Application::HeaderHelpers
  def navbar_style
    if current_user || controller_name == "groups"
      "navbar-dark bg-primary-dark"
    else
      "navbar-light"
    end
  end

  def dark_header?
    current_user || controller_name == "groups"
  end

  def header_logo_style
    if current_user || controller_name == "groups"
      "header-logo--light"
    else
      "header-logo--dark"
    end
  end

  def log_in_button_style
    if current_user || controller_name == "groups"
      "btn-outline-light"
    else
      "btn-outline-primary"
    end
  end

  def sign_up_button_style
    if current_user || controller_name == "groups"
      "btn-light"
    else
      "btn-primary"
    end
  end

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
