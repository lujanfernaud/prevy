# A sample group created for every new user.
class SampleGroup

  def self.create_for_user(user)
    new(user).create_sample_group
  end

  def initialize(user)
    @user  = user
    @group = nil
  end

  def create_sample_group
    create_group
    add_sample_members
    build_sample_event
  end

  private

    attr_reader :user, :group

    def create_group
      @group = user.owned_groups.create!(
        name:         group_name,
        description:  group_description,
        location:     group_location,
        image:        group_image,
        sample_group: true
      )
    end

    def group_name
      I18n.t("sample_group.name")
    end

    def group_description
      I18n.t(
        "sample_group.description",
        user_name: user.name,
        new_group_link: Rails.application.routes.url_helpers.new_group_path
      )
    end

    def group_location
      I18n.t("sample_group.location")
    end

    def group_image
      File.open("app/assets/images/samples/cristina-cerda-43101-unsplash.jpg")
    end

    def add_sample_members
      SampleUser.all.each do |user|
        group.members << user
        user.add_role :member, group
      end
    end

    def build_sample_event
      SampleEvent.build_for_group(group)
    end

end
