access_token = Figaro.env.mapbox_access_token

Leaflet.tile_layer = "https://api.mapbox.com/v4/" \
  "mapbox.streets/{z}/{x}/{y}.png?access_token=" + access_token
Leaflet.attribution = '© ' \
  '<a href="https://www.mapbox.com/feedback/">Mapbox</a>' \
  ' © <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
Leaflet.max_zoom = 20
