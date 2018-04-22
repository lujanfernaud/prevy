module GeocoderSupport
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
end
