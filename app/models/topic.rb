# frozen_string_literal: true

class Topic < ApplicationRecord
  include FriendlyId
  friendly_id :slug_candidates, use: :scoped, scope: :group

  belongs_to :group
  belongs_to :user

  has_many :topic_comments, dependent: :destroy

  validates :title, presence: true, length: { minimum: 2 }
  validates :body,  presence: true, length: { minimum: 20 }

  def comments
    topic_comments
  end

  private

    def should_generate_new_friendly_id?
      title_changed?
    end

    def slug_candidates
      [
        :title,
        [:title, :date]
      ]
    end

    def date
      Time.zone.now.strftime("%b %d %Y")
    end
end
