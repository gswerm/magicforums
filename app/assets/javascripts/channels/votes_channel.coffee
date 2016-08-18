votesChannelFunctions = () ->

  if $('.comments.index').length > 0
    App.votes_channel = App.cable.subscriptions.create {
      channel: "VotesChannel"
    },
    connected: () ->
      console.log("User Login")
    disconnected: () ->
      console.log("User Login")
    received: (data) ->
      $(".comment[data-id=#{data.comment_id}] .voting-score").html(data.value)

$(document).on 'turbolinks:load', votesChannelFunctions
