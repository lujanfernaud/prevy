# frozen_string_literal: true

# Used to authorize member in Groups::MembersController.
class Member
  attr_reader :group

  def initialize(user, group)
    @user  = user
    @group = group
  end
end
