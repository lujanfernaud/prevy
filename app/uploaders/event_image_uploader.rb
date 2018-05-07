# The main purpose of this class is to set a default image for sample events.
#
# When creating a sample event for new users, the image field
# is left blank, validation skipped, and the event gets to
# have the image we are setting on 'default_url'.

class EventImageUploader < ImageUploader

  def default_url(*args)
    "/images/samples/" + [version_name, "sample_event.jpg"].compact.join('_')
  end

end
