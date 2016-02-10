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

  $(".not-connected-remote-rental").droppable
    accept: ".bookingsync-rental"
    activeClass: "dropzone-active"
    hoverClass: "dropzone-hover"
    greedy: true
    tolerance: "pointer"
    drop: (event, ui) ->
      remoteRental = $(@)

      rentalId = extractIdFromDomId($(ui.draggable).attr("id"))
      remoteRentalId = extractIdFromDomId(remoteRental.attr("id"))
      remoteRentalUid = remoteRental.data("uid")

      remoteRental.replaceWith HandlebarsTemplates["rentals/connected_rental"]
        rentalName: $(ui.draggable).children('.panel-heading').text()
        rentalDescription: $(ui.draggable).children('.panel-body').html()
        rentalId: rentalId
        listingId: "Listing #" + remoteRentalUid
      $(ui.draggable).remove()

      connect_url = $('.remote-rentals-list.rentals-list').data('connect-url')

      $.ajax
        url: connect_url
        type: "POST"
        data: { "rental_id": rentalId, "remote_rental_id": remoteRentalId }
        dataType: 'json'
        beforeSend: ->
          $(@).addClass('loading')
        success: ->
          $(@).removeClass('loading')

  $(".new-remote-rental").droppable
    accept: ".bookingsync-rental"
    activeClass: "dropzone-active"
    hoverClass: "dropzone-hover"
    greedy: true
    tolerance: "pointer"
    drop: (event, ui) ->
      newRemoteRental = $(@)

      rentalId = extractIdFromDomId($(ui.draggable).attr("id"))
      remoteAccountId = $(@).data("remote-account-id")

      newRental = HandlebarsTemplates["rentals/connected_rental"]
        rentalName: $(ui.draggable).children('.panel-heading').text()
        rentalDescription: $(ui.draggable).children('.panel-body').html()
        rentalId: rentalId

      $(newRental).insertBefore(newRemoteRental).addClass('pending')

      $(ui.draggable).remove()

      connect_url = $('.remote-rentals-list.rentals-list').data('connect-url')
      
      $.ajax
        url: connect_url
        type: "POST"
        data: { "rental_id": rentalId, "remote_account_id": remoteAccountId }
        dataType: 'json'
        beforeSend: ->
          $(@).addClass('loading')
        success: ->
          $(@).removeClass('loading')
