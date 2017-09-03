# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

27.times do
  User.create(name: Faker::Internet.user_name.capitalize,
              email: Faker::Internet.email,
              password: "password",
              password_confirmation: "password")
end

titles = [Faker::RockBand.name, Faker::BossaNova.artist, Faker::Book.title]

54.times do
  start_date = Faker::Date.between(6.months.ago, 6.months.from_now)
  end_date   = start_date + 1.day

  Event.create(title: titles.sample,
               description: Faker::Lorem.paragraph,
               start_date: start_date,
               end_date: end_date,
               organizer_id: rand(28))
end
