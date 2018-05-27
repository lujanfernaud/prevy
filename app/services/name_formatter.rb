# frozen_string_literal: true

# This is mainly to remove the email part in case a user types
# the email in the name field.
#
# We try to sort it out on our own, not telling the user that
# he or she did something wrong.
class NameFormatter

  EMAIL_PART = /@.*/
  SEPARATORS = /\.|_|-/

  def self.call(input)
    new(input).format
  end

  def initialize(input)
    @input = input
  end

  def format
    return sanitized_input if input_looks_like_a_name?

    remove_email_from_input
    sanitized_input
  end

  private

    attr_reader :input

    def sanitized_input
      input.strip.titleize
    end

    def input_looks_like_a_name?
      input.match(/.*\s.*/) && !input.match(/@.*/)
    end

    def remove_email_from_input
      @input = input.gsub(SEPARATORS, " ").gsub(EMAIL_PART, "")
    end

end
