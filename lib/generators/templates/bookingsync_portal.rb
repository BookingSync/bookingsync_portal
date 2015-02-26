# Use this to customize the behaviour of BookingsyncPortal engine and hook up custom synchronization
BookingsyncPortal.setup do |config|
  # customize account model class, can extend BookingsyncPortal::Account
  # config.account_model = '::Account'

  # customize remote account model class, can extend BookingsyncPortal::RemoteAccount
  # config.remote_account_model = '::RemoteAccount'

  # customize rental model class, can extend BookingsyncPortal::Rental
  # config.rental_model = '::Rental'

  # customize remote_rental model class, can extend BookingsyncPortal::RemoteRental
  # config.remote_rental_model = '::RemoteRental'

  # customize connection model class, can extend BookingsyncPortal::Connection
  # config.connection_model = '::RemoteAccount'

  # customize account resource class, can extend BookingsyncPortal::Admin::AccountResource
  # config.account_resource = '::Admin::AccountResource'

  # customize remote account resource class, can extend BookingsyncPortal::Admin::RemoteAccountResource
  # config.remote_account_resource = '::Admin::RemoteAccountResource'

  # customize rental resource class, can extend BookingsyncPortal::Admin::RentalResource
  # config.rental_resource = '::Admin::RentalResource'

  # customize remote rental resource class, can extend BookingsyncPortal::Admin::RemoteRentalResource
  # config.remote_rental_resource = '::Admin::RemoteRentalResource'

  # customize connection resource class, can extend BookingsyncPortal::Admin::ConnectionResource
  # config.connection_resource = '::Admin::ConnectionResource'

  # handle synchronization of rentals after connection is made
  def config.connection_created(connection)
  end

  # handle synchronization of rentals after connection is destroyed
  def config.connection_destroyed(connection)
  end

  # fetch remote rentals
  def config.fetch_remote_rentals(account)
    # return false if remote account is not present or not valid
  end
end

