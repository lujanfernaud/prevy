$(document).on "turbolinks:load", ->
  $("body").tooltip
    html:     true,
    delay:    { "show": 400, "hide": 100 },
    selector: "#user-points"
