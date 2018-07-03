# frozen_string_literal: true

require 'test_helper'

class GroupsHelperTest < ActionView::TestCase
  def setup
    @phil     = users(:phil)
    @penny    = users(:penny)
    @onitsuka = users(:onitsuka)
    @nike     = groups(:one)
  end

  test "#has_organizer_role?" do
    @phil.add_role(:organizer, @nike)

    assert has_organizer_role?(@phil, @nike)
    refute has_organizer_role?(@onitsuka, @nike)
  end

  test "#has_member_role?" do
    @penny.add_role(:member, @nike)

    assert has_member_role?(@penny, @nike)
    refute has_member_role?(@onitsuka, @nike)
  end

  test "#authorized?" do
    assert authorized?(@phil, @nike)
    refute authorized?(@onitsuka, @nike)
  end

  test "#has_membership?" do
    assert has_membership?(@penny, @nike)
    refute has_membership?(@onitsuka, @nike)
  end
end
