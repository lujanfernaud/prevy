$(document).on "turbolinks:load", ->
  startSmoothScroll()


# -----------------
# startSmoothScroll
# -----------------


startSmoothScroll = ->
  isEventsShowView = $(".events.show").length > 0
  isGroupsShowView = $(".groups.show").length > 0

  return unless isEventsShowView || isGroupsShowView

  new SmoothScroll('a[href*="#"]')
