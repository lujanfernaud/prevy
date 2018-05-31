# frozen_string_literal: true

class BodyLengthValidator
  LEADING_SPACES  = /\A\p{Space}*/
  TRAILING_SPACES = /\p{Space}*\z/

  def self.call(record, params = {})
    new(record, params).validate
  end

  def initialize(record, params)
    @record = record
    @body   = record.body
    @length = params[:length]
    @parser = params[:parser] || HTMLToStringParser
  end

  def validate
    add_error unless body_is_long_enough?
  end

  private

    attr_reader :record, :body, :length, :parser

    def add_error
      record.errors.add(
        :body, "is too short (minimum is #{length} characters)"
      )
    end

    def body_is_long_enough?
      body_without_leading_and_trailing_spaces.length > length
    end

    def body_without_leading_and_trailing_spaces
      parsed_body.gsub(LEADING_SPACES, "").gsub(TRAILING_SPACES, "")
    end

    def parsed_body
      parser.call(body)
    end

end
