# frozen_string_literal: true

module Application::HeaderHelpers
  def navbar_style
    if dark_header?
      "navbar-dark bg-primary-dark"
    else
      "navbar-light"
    end
  end

  def dark_header?
    current_user || groups_controller? || searches_controller?
  end

  def groups_controller?
    controller_name == "groups"
  end

  def searches_controller?
    controller_name == "searches"
  end

  def prevy_logo_style
    if dark_header?
      "prevy-logo--light"
    else
      "prevy-logo--dark"
    end
  end

  def log_in_button_style
    if dark_header?
      "btn-outline-light"
    else
      "btn-outline-primary"
    end
  end

  def sign_up_button_style
    if dark_header?
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
