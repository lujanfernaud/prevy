require 'test_helper'

class EventTest < ActiveSupport::TestCase
  test "is valid" do
    event = fake_event
    assert event.valid?
  end

  test "is invalid without title" do
    event = fake_event(title: "")
    refute event.valid?
  end

  test "is invalid with short title" do
    event = fake_event(title: "Eve")
    refute event.valid?
  end

  test "is invalid without description" do
    event = fake_event(description: "")
    refute event.valid?
  end

  test "is invalid with short description" do
    event = fake_event(description: "An event")
    refute event.valid?
  end

  test "is invalid without image" do
    event = fake_event(image: "")
    refute event.valid?
  end

  test "is invalid with a start date that has already passed" do
    event = fake_event(start_date: Time.zone.now - 1.day)
    refute event.valid?
  end

  test "is invalid with an end date that has already passed" do
    event = fake_event(end_date: Time.zone.now - 1.day)
    refute event.valid?
  end

  test "is invalid without a street" do
    event = fake_event(street1: "")
    refute event.valid?
  end

  test "is invalid without a city" do
    event = fake_event(city: "")
    refute event.valid?
  end

  test "is invalid without a post code" do
    event = fake_event(post_code: "")
    refute event.valid?
  end

  test "is invalid without a country" do
    event = fake_event(country: "")
    refute event.valid?
  end

  test "adds protocol to event's website before saving if missing" do
    event = fake_event(website: "www.eventwebsite.com")
    event.save!

    assert_equal event.website, "https://" + "www.eventwebsite.com"
  end

  test "delegates address methods" do
    event = fake_event

    assert event.place_name
    assert event.street1
    assert event.street2
    assert event.city
    assert event.state
    assert event.post_code
    assert event.country
  end

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

  def fake_event(params = {})
    @fake_event ||= Event.new(
      title:       params[:title]       || "Test event",
      description: params[:description] || Faker::Lorem.paragraph,
      website:     params[:website]     || "",
      start_date:  params[:start_date]  || Time.zone.now + 6.days,
      end_date:    params[:end_date]    || Time.zone.now + 1.week,
      image:       params[:image]       || image,
      organizer:   users(:phil),
      address_attributes: address(params)
    )
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
