module UserSupport
  def new_user
    @new_user ||= User.create!(
      name:                  "New user",
      email:                 "newuser@test.test",
      password:              "password",
      password_confirmation: "password",
      confirmed_at:          Time.zone.now - 1.day,
      location:              Faker::Address.city,
      bio:                   Faker::BackToTheFuture.quote
    )
  end
end
