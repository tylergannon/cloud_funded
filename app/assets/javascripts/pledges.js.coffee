# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.perk').each (idx) ->
    $this = $(this)
    $this.find('input[type=\'radio\']').data('perk', $this)
    $this.data('price', parseInt($this.data('price')))
    
  pledgeAmount = -> parseInt($('#pledge_amount').val().replace(/\D/g, ''))

  $("#stripe_payment_form").submit (event) ->
    $(".submit").attr "disabled", "disabled"
    Stripe.setPublishableKey stripePublishableKey
    Stripe.createToken
      number: $('#cc_number').val()
      cvc: $('#cc_cvc').val()
      exp_month: $('#cc_month').val()
      exp_year: $('#cc_year').val()
    , stripeResponseHandler
    false
    
  $('#pledge_amount').change -> pledge_amount = $(this).val()
  $('#pledge_amount').keyup ->
    pledge_amount = pledgeAmount()
    $('.perk').each (idx) ->
      $this = $(this)
      if pledge_amount >= parseInt($this.data('price'))
        $this.addClass('available')
        console.log('nicebaz')
      else
        $this.removeClass('available')
  $('.perk input[type=\'radio\']').change () ->
    $this = $(this)
    $perk = $this.data('perk')
    price = $perk.data('price')
    unless pledgeAmount() > 0
      $('#pledge_amount').val(price)
      $('#pledge_amount').keyup()
    else
      if price > pledgeAmount()
        unless confirm('Choosing the ' + $perk.data('name') + ' will increase your pledge amount.  Ok?')
          $this.prop('selected', false)
        else
          $('#pledge_amount').val(price)
          $('#pledge_amount').keyup()
      
stripeResponseHandler = (status, response) ->
  window.status = status
  window.response = response
  if response.error
    $('.payment_error .message').text response.error.message
    $('.payment_error').removeClass('hidden')
    $(".submit").removeAttr "disabled"
  else
    $form = $("#stripe_payment_form")
    token = response["id"]
    $form.append "<input type='hidden' name='stripe_token' value='" + token + "'/>"
    $form.get(0).submit()
