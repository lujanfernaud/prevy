# frozen_string_literal: true

class HTMLToStringParser

  def self.call(input, parser = Nokogiri::HTML)
    new(input, parser).parse
  end

  def initialize(input, parser)
    @input  = input
    @parser = parser
  end

  def parse
    parser.parse(input).text
  end

  private

    attr_reader :input, :parser
end
