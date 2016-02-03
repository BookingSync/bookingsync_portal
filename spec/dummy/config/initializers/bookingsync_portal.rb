# To allow customizing models or resources you can easily extend models and resources
# Uncomment lines below with customized classes names

# BookingsyncPortal.account_model = '::Account'
# BookingsyncPortal.remote_account_model = '::RemoteAccount'
# BookingsyncPortal.rental_model = '::Rental'
# BookingsyncPortal.remote_rental_model = '::RemoteRental'
# BookingsyncPortal.connection_model = '::Connection'

module BookingsyncPortal
  def self.connection_created(connection)
    # handle connection created here
  end

  def self.connection_destroyed(connection)
    # handle connection destroyed here
  end

  def self.fetch_remote_rentals(account)
    # handle fetching remote rentals
    # return false if fetching was not successful due to remote accounts or remote api problems
  end
end

BookingsyncPortal.setup do |config|
  config.source_name = "Dummy".freeze
end
