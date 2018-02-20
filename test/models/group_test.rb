require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test "is valid" do
    assert fake_group.valid?
  end

  test "is invalid without name" do
    group = fake_group(name: "")
    refute group.valid?
  end

  test "is invalid with short name" do
    group = fake_group(name: "Gr")
    refute group.valid?
  end

  test "is invalid without description" do
    group = fake_group(description: "")
    refute group.valid?
  end

  test "is invalid with short description" do
    group = fake_group(description: "Our group")
    refute group.valid?
  end

  test "is invalid without an image" do
    group = fake_group(image: "")
    refute group.valid?
  end

  test "#owner" do
    group = fake_group(owner: users(:penny))

    assert_equal group.owner.name, "Penny"
  end

  test "#members" do
    group   = groups(:one)
    penny   = users(:penny)
    woodell = users(:woodell)

    assert_equal group.members, [penny, woodell]
  end

  test "#events" do
    group = groups(:one)

    assert group.events.count > 1
  end

  private

    def fake_group(params = {})
      @fake_group ||= Group.new(
        owner:       params[:owner]       || users(:phil),
        name:        params[:name]        || "Test group",
        description: params[:description] || Faker::Lorem.paragraph,
        image:       params[:image]       || valid_image,
        private:     params[:private]     || true,
        hidden:      params[:hidden]      || true,
        all_members_can_create_events:
          params[:all_members_can_create_events] || true
      )
    end

    def valid_image
      File.open(Rails.root.join("test/fixtures/files/sample.jpeg"))
    end
end
