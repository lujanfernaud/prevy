# Globally executed scripts.

$(document).on "turbolinks:load", ->
  startBootstrapTooltip()
  preventTrixFromAcceptingImageAttachments()


# ---------------------
# startBootstrapTooltip
# ---------------------


startBootstrapTooltip = ->
  $("[data-behavior~=tooltip]").tooltip
    html:  true,
    delay: { "show": 400, "hide": 100 }


# ----------------------------------------
# preventTrixFromAcceptingImageAttachments
# ----------------------------------------


preventTrixFromAcceptingImageAttachments = ->
  document.addEventListener "trix-file-accept", (e) ->
    e.preventDefault()
