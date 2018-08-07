$(document).on "turbolinks:load", ->
  setEventMap()


# -----------
# setEventMap
# -----------
#
# Using Leaflet.js: http://leafletjs.com


setEventMap = ->
  isEventsShowView = $(".events.show").length > 0

  return false unless isEventsShowView

  mapElement   = $("#map")

  token        = mapElement.data("token")
  latitude     = mapElement.data("latitude")
  longitude    = mapElement.data("longitude")
  eventTitle   = mapElement.data("event-title")
  marker       = mapElement.data("marker-url")
  markerRetina = mapElement.data("marker-2x-url")
  shadow       = mapElement.data("shadow-url")

  map = L.map("map").setView([latitude, longitude], 15)

  L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=" + token,
  attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
  maxZoom: 19,
  id: "mapbox.streets",
  accessToken: token
  ).addTo(map)

  myIcon = L.icon(
    iconUrl:   marker,
    retinaUrl: markerRetina,
    shadowUrl: shadow
  )

  L.marker([latitude, longitude], icon: myIcon)
    .addTo(map)
    .bindPopup(eventTitle)

  map.scrollWheelZoom.disable()
