# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def validate_each(record, attribute, value)
    unless value =~ VALID_EMAIL_REGEX
      record.errors[attribute] << error_message
    end
  end

  private

    def error_message
      options[:message] || "is not valid"
    end
end
