$(document).ready ->
  Stripe.setPublishableKey($("#stripePublicKey").val())
  stripeResponseHandler = (status, response) ->
    if (response.error)
      # Show the errors on the form
      $(".paymentErrors").text(response.error.message)
      $(".submitButton").removeAttr("disabled")
      $(".submitButton").text("Proceed to Confirmation")
    else
      $form = $("#paymentForm")
      # token contains id, last4, and card type
      token = response['id']
      # Insert the token into the form so it gets submitted to the server
      $form.append("<input type='hidden' name='stripe_token' value='" + token + "'/>")
      $form.get(0).submit()

  $("#paymentForm").submit (event) ->
    # Disable the submit button to prevent repeated clicks
    $('.submitButton').attr("disabled", "disabled")
    $('.submitButton').text("Validating...")

    Stripe.createToken
        number: $('.cardNumber').val()
        cvc: $('.cardCvc').val()
        exp_month: $('.cardExpiryMonth').val()
        exp_year: $('.cardExpiryYear').val()
    , stripeResponseHandler

    false # Prevent the form from submitting with the default action