# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  admin                  :boolean          default(FALSE)
#  bio                    :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  location               :string
#  name                   :string
#  notifications_count    :integer          default(0), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sample_user            :boolean          default(FALSE)
#  settings               :jsonb            not null
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_slug                  (slug)
#

# Sample users created for sample groups.
class SampleUser < User
  before_create :set_as_confirmed
  before_create :set_as_sample_user

  def self.all
    User.where(sample_user: true)
  end

  def self.collection_for_sample_group
    all[0..-2]
  end

  def self.select_random_users(users_number)
    collection_without_prevy_bot.shuffle.pop(users_number)
  end

  def self.collection_without_prevy_bot
    collection_for_sample_group - [prevy_bot]
  end

  def self.prevy_bot
    User.find_by(email: "prevybot@prevy.test")
  end

  private

    def set_as_confirmed
      self.confirmed_at = Time.zone.now
    end

    def set_as_sample_user
      self.sample_user = true
    end
end
