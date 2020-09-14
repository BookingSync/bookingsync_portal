$("#<%= dom_id @connection.rental %>").first().replaceWith(
  "<%= j render 'bookingsync_portal/admin/rentals/remote_rental', remote_rental: @connection.remote_rental %>")
$(".bookingsync-rentals-list .rentals-list-scroll").first().html(
  "<%= j render 'bookingsync_portal/admin/rentals/rentals', available_listings_count: @available_listings_count, core_listings: @core_listings %>")

$(".bookingsync-rental").draggableRental()
$(".panel.panel-remote").droppableRemoteRental()
