# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Prevent Trix Editor from accepting image attachments when dropping them
# on the field.
document.addEventListener "trix-file-accept", (e) ->
  e.preventDefault()
