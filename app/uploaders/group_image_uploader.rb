# The main purpose of this class is to set a default image for sample groups.
#
# When creating a sample group for new users, the image field
# is left blank, validation skipped, and the group gets to
# have the image we are setting on 'default_url'.

class GroupImageUploader < ImageUploader

  def default_url(*args)
    "/images/samples/" + [version_name, "sample_group.jpg"].compact.join('_')
  end

end
