$ ->
  $(".bookingsync-rental").draggable
    revert: "invalid"
    zIndex: 50
    revertDuration: 100
    cursor: "move"
    containment: '.rentals-container'
    appendTo: '.rentals-container'
    helper: "clone"
    scroll: false

    start: (e, ui) ->
      $(ui.helper).addClass "ui-draggable-helper"

  $(".panel.panel-remote").droppable
    accept: ".bookingsync-rental"
    activeClass: "dropzone-active"
    hoverClass: "dropzone-hover"
    greedy: true
    tolerance: "pointer"
    drop: (event, ui) ->
      remoteRentalDropZone = $(@)

      rentalId = extractIdFromDomId($(ui.draggable).attr("id"))
      remoteRentalId = extractIdFromDomId(remoteRentalDropZone.attr("id"))
      remoteAccountId = remoteRentalDropZone.data("remote-account-id")
      remoteRentalUid = remoteRentalDropZone.data("uid")

      if remoteRentalId
        postData = { "rental_id": rentalId, "remote_rental_id": remoteRentalId }
      else
        postData = { "rental_id": rentalId, "remote_account_id": remoteAccountId }
        # clone new remote rental drop zone and append to the end
        remoteRentalDropZone.clone().insertBefore(remoteRentalDropZone).addClass('new_rental_placeholder');

      $(ui.draggable).remove()

      connect_url = $('.remote-rentals-list.rentals-list').data('connect-url')

      $.ajax
        url: connect_url
        type: "POST"
        data: postData
        dataType: 'script'
        beforeSend: ->
          $(@).addClass('loading')
        success: ->
          $(@).removeClass('loading')
