$ ->
  messagebus_channel = $("body").data("messagebus-channel")
  MessageBus.start()
  MessageBus.subscribe messagebus_channel, (data) ->
    if data.refresh_from
      $.get(data.refresh_from).fail (xhr) ->
        location.reload() if xhr.status == 401
