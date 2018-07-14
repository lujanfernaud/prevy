# frozen_string_literal: true

# Sample invitations created for every new user's sample group.
class SampleInvitation
  CREATION_DATE      = 1.day.ago
  ONE_MINUTE         = 60
  TWENTY_THREE_HOURS = 82_200

  def self.create_invitations_for(group, quantity:)
    new(group, quantity).create_sample_invitations
  end

  def initialize(group, quantity)
    @group       = group
    @quantity    = quantity
    @invitations = []
  end

  def create_sample_invitations
    build_invitations

    GroupInvitation.import(@invitations)
  end

  private

    attr_reader :group, :quantity

    def build_invitations
      quantity.times do
        @invitations << new_invitation
      end
    end

    def new_invitation
      date       = CREATION_DATE + rand(ONE_MINUTE..TWENTY_THREE_HOURS)
      first_name = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      full_name  = "#{first_name} #{last_name}"

      group.invitations.new(
        sender:     group.owner,
        name:       first_name,
        email:      Faker::Internet.free_email(full_name),
        created_at: date
      )
    end
end
