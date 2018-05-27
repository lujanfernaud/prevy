require 'test_helper'

class NameFormatterTest < ActiveSupport::TestCase
  test "returns titleized input" do
    input = "laurie bream"

    result = NameFormatter.call(input)

    assert_equal "Laurie Bream", result
  end

  test "returns titleized and stripped input" do
    input = " laurie bream  "

    result = NameFormatter.call(input)

    assert_equal "Laurie Bream", result
  end

  test "returns input if it looks like an username" do
    input = "laurie4"

    result = NameFormatter.call(input)

    assert_equal "Laurie4", result
  end

  test "converts email to name" do
    input = "laurie.bream@test.test"

    result = NameFormatter.call(input)

    assert_equal "Laurie Bream", result
  end

  test "converts email with underscore to name" do
    input = "laurie_bream@test.test"

    result = NameFormatter.call(input)

    assert_equal "Laurie Bream", result
  end

  test "converts email with dash to name" do
    input = "laurie-bream@test.test"

    result = NameFormatter.call(input)

    assert_equal "Laurie Bream", result
  end

  test "removes email part from input" do
    input = "lauriebream@test.test"

    result = NameFormatter.call(input)

    assert_equal "Lauriebream", result
  end
end
