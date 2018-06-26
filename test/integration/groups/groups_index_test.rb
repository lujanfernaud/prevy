require 'test_helper'

class GroupsIndexTest < ActionDispatch::IntegrationTest
  def setup
    @phil = users(:phil)
    @onitsuka = users(:onitsuka)
  end

  test "user visits groups index" do
    groups = Group.unhidden

    visit groups_path

    groups.each do |group|
      assert page.has_css? ".group-box"
      assert page.has_link? group.name
    end
  end

  test "user sees topics link if owner" do
    group = fake_group(owner: @phil)
    group.save

    log_in_as @phil

    visit groups_path

    within "#group-#{group.id}" do
      assert page.has_link? "topics"
      refute page.has_link? "members"
    end
  end

  test "user sees topics link if member" do
    group = fake_group(owner: @phil)
    group.save
    group.members << @onitsuka

    log_in_as @onitsuka

    visit groups_path

    within "#group-#{group.id}" do
      assert page.has_link? "topics"
      refute page.has_link? "members"
    end
  end

  test "user sees members count if not member or owner" do
    group = fake_group(owner: @phil)
    group.save

    log_in_as @onitsuka

    visit groups_path

    within "#group-#{group.id}" do
      refute page.has_link? "topics"
      assert page.has_content? "members"
    end
  end

  private

    # TODO: Extract to a support file.
    def fake_group(params = {})
      Group.new(
        owner:        params[:owner]        || users(:phil),
        name:         params[:name]         || "Test group",
        location:     params[:location]     || Faker::Address.city,
        description:  params[:description]  || Faker::Lorem.paragraph * 2,
        image:        params[:image]        || valid_image,
        sample_group: params[:sample_group] || false,
        hidden:       params[:hidden]       || false,
        all_members_can_create_events:
          params[:all_members_can_create_events] || false
      )
    end
end
