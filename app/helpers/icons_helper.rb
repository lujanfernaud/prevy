# frozen_string_literal: true

module IconsHelper
  def bell_icon(style: '')
    octicon "bell", class: "#{style}"
  end

  def location_icon
    octicon "location"
  end

  def calendar_icon
    octicon "calendar"
  end

  def link_icon
    octicon "link"
  end

  def topics_icon
    octicon "comment-discussion"
  end

  def comments_icon
    octicon "comment"
  end

  def person_icon
    octicon "person"
  end

  def people_icon
    octicon "organization"
  end

  def rocket_icon
    octicon "rocket"
  end

  def shield_icon
    octicon "shield"
  end

  def star_icon
    octicon "star"
  end
end
