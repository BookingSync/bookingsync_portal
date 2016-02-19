$("#<%= dom_id @connection.rental %>").first().replaceWith(
  "<%=j render 'bookingsync_portal/admin/rentals/remote_rental', remote_rental: @connection.remote_rental %>")
$(".bookingsync-rentals-list .rentals-list-scroll").first().html(
  "<%=j render 'bookingsync_portal/admin/rentals/rentals', visible_rentals: @visible_rentals, not_connected_rentals: @not_connected_rentals %>");

$(".bookingsync-rental").draggableRental()
$(".panel.panel-remote").droppableRemoteRental()
