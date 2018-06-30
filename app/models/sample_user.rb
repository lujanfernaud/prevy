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
