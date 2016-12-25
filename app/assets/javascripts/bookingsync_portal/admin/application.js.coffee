# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require jquery-ui/widgets/draggable
#= require jquery-ui/widgets/droppable
#= require handlebars.runtime
#= require message-bus
#= require bootstrap/alert
#= require bootstrap/collapse
#= require bookingsync/form
#= require ./vendor/css-contains
#= require ./lib/list-filter
#= require_tree ./templates
#= require_tree .

window.extractIdFromDomId = (attribute) ->
  if attribute
    attribute.split("_").pop()
$.fn.extend
  draggableRental: ->
    settings =
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

    @each () ->
      $(this).draggable(settings)

  droppableRemoteRental: ->
    settings =
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
    @each () ->
      $(this).droppable(settings)
