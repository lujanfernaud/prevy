class PopulateTopicCommentsCount < ActiveRecord::Migration[5.1]
  def up
    User.find_each do |user|
      User.reset_counters(user.id, :topic_comments)
    end
  end
end
