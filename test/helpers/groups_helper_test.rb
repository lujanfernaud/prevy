# frozen_string_literal: true

require 'test_helper'

class GroupsHelperTest < ActionView::TestCase
  def setup
    @phil     = users(:phil)
    @penny    = users(:penny)
    @onitsuka = users(:onitsuka)
    @nike     = groups(:one)
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
