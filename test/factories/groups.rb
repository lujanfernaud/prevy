# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id                            :bigint(8)        not null, primary key
#  all_members_can_create_events :boolean          default(FALSE)
#  description                   :string
#  hidden                        :boolean          default(FALSE)
#  image                         :string
#  location                      :string
#  name                          :string
#  sample_group                  :boolean          default(FALSE)
#  slug                          :string
#  topics_count                  :integer          default(0), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :bigint(8)
#
# Indexes
#
#  index_groups_on_location  (location)
#  index_groups_on_slug      (slug)
#  index_groups_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
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
