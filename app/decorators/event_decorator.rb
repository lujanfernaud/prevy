class EventDecorator < SimpleDelegator
  def self.collection(events)
    events.map { |event| EventDecorator.new(event) }
  end

  def full_address
    return unless address

    attributes = [place_name, street1, street2, city, state, post_code]

    attributes.reject(&:blank?).map(&:strip).join(", ")
  end

  def short_address
    return unless address

    attributes = [place_name, city]

    attributes.reject(&:blank?).map(&:strip).join(", ")
  end

  def start_date_prettyfied
    happens_this_year? ? start_date_formatted : start_date_formatted_with_year
  end

  def end_date_prettyfied
    happens_this_year? ? end_date_formatted : end_date_formatted_with_year
  end

  def website_prettyfied
    website.gsub("https://", "")
  end

  private

    def happens_this_year?
      start_date.year == Time.zone.now.year
    end

    def start_date_formatted
      start_date.strftime("%A, %b. %d, %H:%M")
    end

    def start_date_formatted_with_year
      start_date.strftime("%A, %b. %d, %Y, %H:%M")
    end

    def end_date_formatted
      if same_day?
        end_date.strftime("%H:%M")
      else
        end_date.strftime("%A, %b. %d, %H:%M")
      end
    end

    def end_date_formatted_with_year
      if same_day?
        end_date.strftime("%H:%M")
      else
        end_date.strftime("%A, %b. %d, %Y, %H:%M")
      end
    end

    def same_day?
      start_date.strftime("%A, %b. %d") == end_date.strftime("%A, %b. %d")
    end
end
