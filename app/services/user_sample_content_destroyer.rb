# frozen_string_literal: true

class UserSampleContentDestroyer
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @sample_group = user.sample_group
  end

  def call
    if sample_group
      sample_group.destroy
      true
    else
      false
    end
  end

  private

    attr_reader :sample_group
end
