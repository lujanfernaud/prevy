# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  email                  :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  location               :string
#  bio                    :string
#  settings               :jsonb            not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  sample_user            :boolean          default(FALSE)
#  admin                  :boolean          default(FALSE)
#  slug                   :string
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

  # Prevy Bot has index 0. We want to exclude it.
  def self.select_random_users(users_number)
    collection_for_sample_group[1..-1].shuffle.pop(users_number)
  end

  private

    def set_as_confirmed
      self.confirmed_at = Time.zone.now
    end

    def set_as_sample_user
      self.sample_user = true
    end
end
