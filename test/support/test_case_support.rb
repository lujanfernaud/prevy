module TestCaseSupport
  def stub_requests_to_googleapis
    WebMock.stub_request(:get, /maps.googleapis.com/)
           .to_return(status: 200, body: "", headers: {})
  end

  def fake_group(params = {})
    Group.new(
      owner:        params[:owner]        || users(:phil),
      name:         params[:name]         || "Test group",
      location:     params[:location]     || Faker::Address.city,
      description:  params[:description]  || Faker::Lorem.paragraph * 2,
      image:        params[:image]        || valid_image,
      sample_group: params[:sample_group] || false,
      hidden:       params[:hidden]       || true,
      all_members_can_create_events:
        params[:all_members_can_create_events] || true
    )
  end

  def fake_event(params = {})
    Event.new(
      group:        params[:group]        || groups(:two),
      title:        params[:title]        || "Test event",
      description:  params[:description]  || Faker::Lorem.paragraph,
      website:      params[:website]      || "",
      start_date:   params[:start_date]   || 6.days.from_now,
      end_date:     params[:end_date]     || 1.week.from_now,
      image:        params[:image]        || valid_image,
      sample_event: params[:sample_event] || false,
      organizer:    params[:user]         || users(:phil),
      address_attributes: address(params)
    )
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

  def valid_image
    File.open(valid_image_location)
  end

  def valid_image_location
    Rails.root.join("test/fixtures/files/sample.jpg").to_s
  end

  def fake_topic(params = {})
    Topic.new(
      group: params[:group] || groups(:one),
      user:  params[:user]  || users(:phil),
      title: params[:title] || "Welcome!",
      body:  params[:body]  || "Welcome to the group :)",
      type:  params[:type]  || "Topic"
    )
  end

  def fake_comment(params = {})
    TopicComment.new(
      topic: params[:topic] || topics(:one),
      user:  params[:user]  || users(:penny),
      body:  params[:body]  || "Hey! Welcome :)"
    )
  end
end
