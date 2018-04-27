$(document).on "turbolinks:load", ->
  preventTrixFromAcceptingImageAttachments()
  setEventMap()
  startSmoothScroll()


# ----------------------------------------
# preventTrixFromAcceptingImageAttachments
# ----------------------------------------


preventTrixFromAcceptingImageAttachments = ->
  document.addEventListener "trix-file-accept", (e) ->
    e.preventDefault()


# -----------
# setEventMap
# -----------
#
# Using Leaflet.js: http://leafletjs.com


setEventMap = ->
  mapIsPresent = document.querySelector("#map")

  return false unless mapIsPresent

  token        = $("#map").data("token")
  latitude     = $("#map").data("latitude")
  longitude    = $("#map").data("longitude")
  eventTitle   = $("#map").data("event-title")
  marker       = $("#map").data("marker-url")
  markerRetina = $("#map").data("marker-2x-url")
  shadow       = $("#map").data("shadow-url")

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


# -----------------
# startSmoothScroll
# -----------------


startSmoothScroll = ->
  new SmoothScroll('a[href*="#"]')
