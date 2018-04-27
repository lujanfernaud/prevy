$(document).on "turbolinks:load", ->
  startClipboardJS()


# ----------------
# startClipboardJS
# ----------------


startClipboardJS = ->
  button    = "#btn-group-link"
  clipboard = new ClipboardJS button

  clipboard.on "success", ->
    showTooltip()

  showTooltip = ->
    $(button).tooltip "enable"
    $(button).tooltip "show"

  $(button).on "shown.bs.tooltip", ->
    setTimeout(hideTooltip, 2000)

  hideTooltip = ->
    $(button).tooltip "hide"
    $(button).tooltip "disable"
