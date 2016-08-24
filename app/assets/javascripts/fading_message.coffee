flashMessagesFunctions = () ->
  ob
  clearFlashMessages = () ->
    setTimeout( ()->
      $('.flash-messages').addClass('fadeOut')
    , 3000)
    setTimeout( ()->
      $('#flash-messages-container').html("")
    , 5000)

  if $('.flash-messages').length > 0
    clearFlashMessages()

$(document).on 'turbolinks:load', flashMessagesFunctions
