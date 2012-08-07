# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $('.perk').each (idx) ->
    $this = $(this)
    $this.find('input[type=\'radio\']').data('perk', $this)
    $this.data('price', parseInt($this.data('price')))
  $('#join_dwolla_email').keyup validateEmailAddress
  

  $("#stripe_payment_form").submit stripePaymentFormSubmitHandler
  $('#pledge_amount').change -> pledge_amount = $(this).val()
  $('#pledge_amount').keyup pledgeAmountKeyUpHandler
  $('.perk input[type=\'radio\']').change changeSelectedPerkHandler
  $('#dwolla_sign_up').click dwollaSignupClickHandler
  $('#dwolla_link_account').click dwollaLinkupClickHandler
  $('#submit-payment').click submitPaymentHandler

submitPaymentHandler = (e) ->
  $('[rel=popover]').popover('hide')
  $('#processing').modal
    keyboard: false

dwollaLinkupClickHandler = (e) ->
  console.log('nicebaz')
  e.preventDefault()
  $('[rel=popover]').popover('hide')
  $('#link_dwolla_modal .modal-body').append('<iframe src="/members/auth/dwolla" frameborder="0" id="dwolla"></iframe>')
  $dwolla = $('#dwolla')
  $dwolla.load () ->
    $dwolla.height(350)
    $dwolla.width(700)
    $('#link_dwolla_modal').modal()
    $('#link_dwolla_modal').on 'hidden', () ->
      $('#dwolla').remove()

dwollaSignupClickHandler = (e) ->
  e.preventDefault()
  $('#sign_up_for_dwolla').modal('show')
  
getPledgeAmount = () -> 
  parseInt($('#pledge_amount').val().replace(/\D/g, ''))
  
validateEmailAddress = () ->
  if this.checkValidity()
    $('#invalid_email').hide()
    $('#sign_up_button').unbind('click', false)
  else
    $('#invalid_email').show()
    $('#sign_up_button').bind('click', false)
  
changeSelectedPerkHandler = () ->
  $this = $(this)
  $perk = $this.data('perk')
  price = $perk.data('price')
  unless getPledgeAmount() > 0
    $('#pledge_amount').val(price)
    $('#pledge_amount').keyup()
  else
    if price > getPledgeAmount()
      unless confirm('Choosing the ' + $perk.data('name') + ' will increase your pledge amount.  Ok?')
        $this.prop('selected', false)
      else
        $('#pledge_amount').val(price)
        $('#pledge_amount').keyup()
  
pledgeAmountKeyUpHandler = ->
  pledge_amount = getPledgeAmount()
  $('.perk').each (idx) ->
    $this = $(this)
    if pledge_amount >= parseInt($this.data('price'))
      $this.addClass('available')
      console.log('nicebaz')
    else
      $this.removeClass('available')

stripePaymentFormSubmitHandler =  (event) ->
  alert('fuck you')
  $(".submit").attr "disabled", "disabled"
  Stripe.setPublishableKey stripePublishableKey
  Stripe.createToken
    number: $('#cc_number').val()
    cvc: $('#cc_cvc').val()
    exp_month: $('#cc_month').val()
    exp_year: $('#cc_year').val()
  , stripeResponseHandler
  false

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
    
