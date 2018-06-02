module UserSupport
  def new_user
    @new_user ||= User.create!(
      name:         "New user",
      email:        "newuser@test.test",
      password:     "password",
      confirmed_at: Time.zone.now - 1.day,
      location:     random_city,
      bio:          random_bio
    )
  end

  def fake_user(params = {})
    User.new(
      name:         params[:name]         || "New user",
      email:        params[:email]        || "newuser@test.test",
      password:     params[:password]     || "password",
      confirmed_at: params[:confirmed_at] || Time.zone.now - 1.day,
      location:     params[:location]     || random_city,
      bio:          params[:bio]          || random_bio
    )
  end

  def random_city
    Faker::Address.city
  end

  def random_bio
    Faker::BackToTheFuture.quote
  end
end
