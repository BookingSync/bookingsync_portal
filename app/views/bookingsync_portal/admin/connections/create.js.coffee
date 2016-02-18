<%- if @connection.persisted? %>
  $("#<%= dom_id @connection.remote_rental %>, .new_rental_placeholder").first().replaceWith(
    "<%=j render 'bookingsync_portal/admin/rentals/connected_rental', rental: @connection.rental, remote_rental: @connection.remote_rental %>");
  $(".bookingsync-rental").draggableRental()
  $(".panel.panel-remote").droppableRemoteRental()
<%- end %>
