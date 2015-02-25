# To allow customizing models or resources you can easily extend models and resources
# Uncomment lines below with customized classes names

# BookingsyncPortal.account_model = '::Account'
# BookingsyncPortal.remote_account_model = '::RemoteAccount'
# BookingsyncPortal.rental_model = '::Rental'
# BookingsyncPortal.remote_rental_model = '::RemoteRental'
# BookingsyncPortal.connection_model = '::Connection'

# BookingsyncPortal.account_resource = '::Admin::AccountResource'
# BookingsyncPortal.remote_account_resource = '::Admin::RemoteAccountResource'
# BookingsyncPortal.rental_resource = '::Admin::RentalResource'
# BookingsyncPortal.remote_rental_resource = '::Admin::RemoteRentalResource'
# BookingsyncPortal.connection_resource = '::Admin::ConnectionResource'

module BookingsyncPortal::Callbacks
  def self.connection_created(connection)
    # handle synchronization of rentals after connection is made
  end

  def self.connection_destroyed(connection)
    # handle synchronization of rentals after connection is destroyed
  end

  def self.fetch_remote_rentals(account)
    # fetch remote rentals
    # return false if remote account is not present or not valid
  end
end
