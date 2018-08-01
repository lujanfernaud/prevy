$(document).on "turbolinks:load", ->
  preventValidationErrorFromAppearing()


# -----------------------------------
# preventValidationErrorFromAppearing
# -----------------------------------

# Prevent client side validation error from appearing when clicking on
# links in 'Log in' and 'Sign up' forms.
#
# If we don't do this, at the moment the autoselected input field is deselected
# when clicking on one of the links, a "can't be blank" validation error
# would appear in the field.

preventValidationErrorFromAppearing = ->
  isSignUpForm = $(".registrations.new").length > 0
  isLoginForm  = $(".sessions.new").length > 0

  return unless isSignUpForm || isLoginForm

  $(document).on "mousedown", "[data-behavior~=prevent-validation-error]", ->
    $("#new_user").disableClientSideValidations();
