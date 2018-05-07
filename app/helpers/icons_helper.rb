module IconsHelper
  def location_icon
    inline_svg location_icon_file, class: "icon icon-location"
  end

  def calendar_icon
    inline_svg calendar_icon_file, class: "icon icon-calendar"
  end

  def link_icon
    inline_svg link_icon_file, class: "icon icon-link"
  end

  private

    def location_icon_file
      "icons/if_icon-ios7-location-outline_211766.svg"
    end

    def calendar_icon_file
      "icons/if_icon-calendar_211633.svg"
    end

    def link_icon_file
      "icons/if_icon-link_211853.svg"
    end
end
