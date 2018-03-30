require 'test_helper'

class EventDecoratorTest < ActiveSupport::TestCase
  test "#full_address returns full address without country" do
    event = fake_event
    full_address = "Obento, Matsubara-dori, 8, Kyoto, 6050856"

    assert_equal event.full_address, full_address
  end

  test "#short_address returns place name and city" do
    event = fake_event
    short_address = "Obento, Kyoto"

    assert_equal event.short_address, short_address
  end

  private

    def fake_event(params = {})
      @fake_event ||= EventDecorator.new(Event.new(
        group:       groups(:two),
        title:       params[:title]       || "Test event",
        description: params[:description] || Faker::Lorem.paragraph,
        website:     params[:website]     || "",
        start_date:  params[:start_date]  || Time.zone.now + 6.days,
        end_date:    params[:end_date]    || Time.zone.now + 1.week,
        image:       params[:image]       || image,
        organizer:   users(:phil),
        address_attributes: address(params)
      ))
    end

    def image
      File.open(Rails.root.join('test/fixtures/files/sample.jpeg'))
    end

    def address(params = {})
      {
        place_name: params[:place_name] || "Obento",
        street1:    params[:street1]    || "Matsubara-dori, 8",
        street2:    params[:street2]    || "",
        city:       params[:city]       || "Kyoto",
        state:      params[:state]      || "",
        post_code:  params[:post_code]  || "6050856",
        country:    params[:country]    || "Japan"
      }
    end
end
