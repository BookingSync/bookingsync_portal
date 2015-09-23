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

      rentalId = parseInt($(ui.draggable).attr("id").split("_").pop())
      remoteRentalId = parseInt(remoteRental.attr("id").split("_").pop())
      remoteRentalUid = parseInt(remoteRental.data("uid"))

      remoteRental.replaceWith HandlebarsTemplates["rentals/connected_rental"]
        rentalName: $(ui.draggable).children('.panel-heading').text()
        rentalDescription: $(ui.draggable).children('.panel-body').html()
        rentalId: rentalId
        listingId: "Listing #" + remoteRentalUid
      $(ui.draggable).remove()

      connect_url = "/en/admin/rentals/" + rentalId + "/connect" +
        "?remote_rental_id=" + remoteRentalId

      $.ajax
        url: connect_url
        type: "PUT"
        dataType: 'json'
        beforeSend: ->
          $(@).addClass('loading')
        success: ->
          $(@).removeClass('loading')

  $(".remote-new-rental").droppable
    accept: ".bookingsync-rental"
    activeClass: "dropzone-active"
    hoverClass: "dropzone-hover"
    greedy: true
    tolerance: "pointer"
    drop: (event, ui) ->
      rentalId = parseInt($(ui.draggable).attr("id").split("_")[1])
      remoteAccountId = parseInt($(@).data("remote-account-id"))

      newRental = HandlebarsTemplates["rentals/connected_rental"]
        rentalName: $(ui.draggable).children('.panel-heading').text()
        rentalDescription: $(ui.draggable).children('.panel-body').html()
        rentalId: rentalId

      rentalsScrollingList = $(@).closest(".rentals-list").find(".rentals-list-scroll")
      $(newRental).appendTo(rentalsScrollingList).addClass('pending')
      rentalsScrollingList.animate
        scrollTop: rentalsScrollingList.prop("scrollHeight")

      $(ui.draggable).remove()

      new_connect_url = "/en/admin/rentals/" + rentalId + "/connect_to_new" +
        "?remote_account_id=" + remoteAccountId

      $.ajax
        url: new_connect_url
        type: "PUT"
        dataType: 'json'
        beforeSend: ->
          $(@).addClass('loading')
        success: ->
          $(@).removeClass('loading')

  for rentalsList, index in $(".rentals-list")
    inputId = "rentals-list-filter-#{index}"
    new ListFilter(
      $(rentalsList).children(".rentals-list-header"),
      $(rentalsList).children(".rentals-list-scroll"),
      ".panel",
      ".panel h4",
      inputId,
      HandlebarsTemplates["filter_input"]
        inputId: inputId
    )
