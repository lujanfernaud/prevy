module TestCaseSupport
  def stub_requests_to_googleapis
    WebMock.stub_request(:get, /maps.googleapis.com/)
           .to_return(status: 200, body: "", headers: {})
  end

  def fake_event(params = {})
    Event.new(
      group:       params[:group]       || groups(:two),
      title:       params[:title]       || "Test event",
      description: params[:description] || Faker::Lorem.paragraph,
      website:     params[:website]     || "",
      start_date:  params[:start_date]  || 6.days.from_now,
      end_date:    params[:end_date]    || 1.week.from_now,
      image:       params[:image]       || valid_image,
      organizer:   params[:user]        || users(:phil),
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
    File.open(Rails.root.join("test/fixtures/files/sample.jpeg"))
  end
end
