# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id                            :bigint(8)        not null, primary key
#  name                          :string
#  description                   :string
#  image                         :string
#  hidden                        :boolean          default(FALSE)
#  all_members_can_create_events :boolean          default(FALSE)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :bigint(8)
#  location                      :string
#  sample_group                  :boolean          default(FALSE)
#  slug                          :string
#


FactoryBot.define do
  factory :group do
    owner
    sequence(:name) { |n| "Test Group #{n}" }
    location        "Tenerife"
    description     { Faker::Lorem.paragraph * 2 }
    image           { Rack::Test::UploadedFile.new("#{Rails.root}/test/fixtures/files/sample.jpg", "image/jpeg") }
  end
end
