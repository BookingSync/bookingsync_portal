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

      template = HandlebarsTemplates["rentals/connecting_rental"]
        rentalName: $(ui.draggable).children('.panel-heading').text()
        rentalDescription: $(ui.draggable).children('.panel-body').html()
        rentalId: rentalId
        listingId: "Listing #" + remoteRentalUid
      if remoteRentalId
        postData = { "rental_id": rentalId, "remote_rental_id": remoteRentalId }
        remoteRentalDropZone.replaceWith(template)
      else
        postData = { "rental_id": rentalId, "remote_account_id": remoteAccountId }
        $(template).insertBefore(remoteRentalDropZone).addClass('pending')

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
