module UserSupport
  def fake_user(params = {})
    User.new(
      name:         params[:name]     || "New user",
      email:        params[:email]    || random_email,
      password:     params[:password] || "password",
      confirmed_at: params[:confirmed_at],
      location:     params[:location] || random_city,
      bio:          params[:bio]      || random_bio
    )
  end

  def random_email
    "newuser#{SecureRandom.hex}@test.test"
  end

  def random_city
    Faker::Address.city
  end

  def random_bio
    Faker::BackToTheFuture.quote
  end
end
