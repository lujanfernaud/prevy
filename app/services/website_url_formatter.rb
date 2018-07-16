# frozen_string_literal: true

class WebsiteUrlFormatter
  def self.call(event)
    new(event).call
  end

  def initialize(event)
    @event   = event
    @website = event.website
  end

  def call
    return if url_has_protocol? || website.empty?

    event.website = "https://" + website
  end

  private

    attr_reader :event, :website

    def url_has_protocol?
      website =~ /http(s)?\:\/\//
    end
end
