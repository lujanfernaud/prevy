require 'test_helper'

class ApplicationRecordTest < ActiveSupport::TestCase
  test "abstract_class is true" do
    assert ApplicationRecord.abstract_class
  end
end
