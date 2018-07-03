# frozen_string_literal: true

module Application::AlertHelpers
  #
  # We do it this way to show these alerts on different places of the layout.
  #

  def create_group_unconfirmed_account_alert
    content_tag :div,
      (create_group_text + confirmation_link).html_safe,
      class: "alert alert-primary text-left"
  end

  def show_group_unconfirmed_account_alert
    content_tag :div,
      (show_group_text + confirmation_link).html_safe,
      class: "alert alert-primary text-left"
  end

  def create_group_text
    I18n.t("pundit.group_policy.create?")
  end

  def show_group_text
    I18n.t("pundit.group_policy.show?")
  end

  def confirmation_link
    I18n.t("pundit.group_policy.confirmation_link",
      confirmation_path: new_user_confirmation_path)
  end
end
