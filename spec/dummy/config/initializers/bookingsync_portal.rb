# Use this to customize the behaviour of BookingsyncPortal engine and hook up custom synchronization
BookingsyncPortal.setup do |config|
  # customize the portal name
  config.portal_name = "Dummy portal app"

  # customize the source name
  config.source_name = "Dummy portal"

  # specify message_bus_channel_scope to allow shared redis setup
  config.message_bus_channel_scope = 'dummy_portal'

  # customize account model class, can extend BookingsyncPortal::Account
  config.account_model = '::Account'

  # customize remote account model class, can extend BookingsyncPortal::RemoteAccount
  config.remote_account_model = '::RemoteAccount'

  # customize rental model class, can extend BookingsyncPortal::Rental
  config.rental_model = '::Rental'

  # customize remote_rental model class, can extend BookingsyncPortal::RemoteRental
  config.remote_rental_model = '::RemoteRental'

  # customize connection model class, can extend BookingsyncPortal::Connection
  config.connection_model = '::Connection'

  # customize photo model class, can extend BookingsyncPortal::Photo
  config.photo_model = '::Photo'

  # customize rate model class, can extend BookingsyncPortal::Rate, set to nil if not used
  config.rate_model = '::Rate'

  # handle synchronization of rentals after connection is made
  # def config.connection_created(connection)
  # end

  # handle synchronization of rentals after connection is destroyed
  # def config.connection_destroyed(connection)
  # end

  # fetch remote rentals
  # def config.fetch_remote_rentals(account)
  #   return false if remote account is not present or not valid
  # end
end
