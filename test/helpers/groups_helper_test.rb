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
    assert authorized?(@penny, @nike)
    refute authorized?(@onitsuka, @nike)
  end
end
