# frozen_string_literal: true

module StubsSupport
  def stub_geocoder
    Geocoder.configure(:lookup => :test)

    Geocoder::Lookup::Test.set_default_stub(
      [
        {
          "latitude"   => 34.997615,
          "longitude"  => 135.775637,
          "place_name" => "Place",
          "street1"    => "Matsubara-dori, 8",
          "city"       => "Kyoto",
          "post_code"  => 6050856,
          "country"    => "Japan"
        }
      ]
    )
  end

  def stub_requests_to_googleapis
    WebMock.stub_request(:get, /maps.googleapis.com/)
           .to_return(status: 200, body: "", headers: {})
  end

  def stub_sample_content_for_new_users
    UserSampleContentCreator.stubs(:call)
  end
end
