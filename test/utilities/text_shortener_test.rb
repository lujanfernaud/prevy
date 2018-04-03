require 'test_helper'

class TextShortenerTest < ActiveSupport::TestCase
  test "shortens text based on characters without breaking words" do
    text = "<div><p>This is a very standard description for an event.</p> " \
           "<p>It should be shortened based on the characters specified, " \
           "without having any words broken.</p></div>"
    expected = "This is a very standard description for an event. " \
               "It should be shortened..."

    shortened_text = TextShortener.call(text: text, characters: 78)

    assert_equal expected, shortened_text
  end
end
