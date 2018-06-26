# frozen_string_literal: true

# Used to authorize group members with Pundit for some particular controllers.
class Member
  attr_reader :group

  def initialize(user, group)
    @user  = user
    @group = group
  end
end
