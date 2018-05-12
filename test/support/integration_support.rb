module IntegrationSupport
  def prepare_javascript_driver
    Capybara.current_driver = :webkit
    Capybara.raise_server_errors = false
  end

  def log_in_as(user)
    visit new_user_session_path
    introduce_log_in_information_as(user)
  end

  def introduce_log_in_information_as(user)
    fill_in "Email",    with: user.email
    fill_in "Password", with: "password"

    within "form" do
      click_on "Log in"
    end
  end

  def log_out_as(user)
    within ".navbar" do
      click_on user.name
      click_on "Log out"
    end
  end

  def select_date_and_time(date, **options)
    return nil unless date

    field = options[:from]
    select date.strftime("%Y"),  from: "#{field}_1i" # Year.
    select date.strftime("%B"),  from: "#{field}_2i" # Month.
    select date.strftime("%-d"), from: "#{field}_3i" # Day.
    select date.strftime("%H"),  from: "#{field}_4i" # Hour.
    select date.strftime("%M"),  from: "#{field}_5i" # Minutes.
  end

  def fill_in_description(description)
    find("trix-editor").click.set(description)
  end

  def attach_valid_image_for(field)
    attach_file field, "test/fixtures/files/sample.jpeg"
  end

  def upload_valid_image
    fixture_file_upload("test/fixtures/files/sample.jpeg", "image/jpeg")
  end

  # We need to do this because Rolify doesn't seem to work very well with
  # fixtures for scoped roles.
  def add_group_owner_to_organizers(group)
    group.owner.add_role(:organizer, group)
  end

  def add_members_to_group(group, *users)
    users.each { |user| user.add_role(:member, group) }
  end

  def assert_create_group_link_enabled
    assert page.has_link? "Create group", { href: new_group_path }
  end

  def assert_create_group_link_disabled
    assert page.has_link? "Create group",
      { href: "", class: "create-group-link disabled" }
  end

  def refute_unconfirmed_account_alerts
    refute_create_group_unconfirmed_alert
    refute_show_group_unconfirmed_alert
  end

  def refute_create_group_unconfirmed_alert
    refute page.has_content? I18n.t("pundit.group_policy.create?")
  end

  def refute_show_group_unconfirmed_alert
    refute page.has_content? I18n.t("pundit.group_policy.show?")
  end

  def assert_create_group_unconfirmed_alert
    assert page.has_content? I18n.t("pundit.group_policy.create?")
  end

  def assert_show_group_unconfirmed_alert
    assert page.has_content? I18n.t("pundit.group_policy.show?")
  end

  def assert_create_group_unconfirmed_button
    assert page.has_css? ".btn-create-group[disabled]"
  end
end
