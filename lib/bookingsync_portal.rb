require 'bookingsync_application'
require 'bookingsync_portal/engine'
require 'bookingsync_portal/mash_serializer'
require 'message_bus'

# FIXME requires below should get removed when ember frontend is added
require 'uglifier'
require 'coffee-rails'
require 'sass-rails'
require 'bootstrap-sass'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'font-awesome-sass'
require 'handlebars_assets'
require 'simple_form'
require 'turbolinks'
require 'responders'

module BookingsyncPortal

  # account model class
  mattr_accessor :account_model
  @@account_model = 'BookingsyncPortal::Account'

  # remote account model class
  mattr_accessor :remote_account_model
  @@remote_account_model = 'BookingsyncPortal::RemoteAccount'

  # rental model class
  mattr_accessor :rental_model
  @@rental_model = 'BookingsyncPortal::Rental'

  # remote rental model class
  mattr_accessor :remote_rental_model
  @@remote_rental_model = 'BookingsyncPortal::RemoteRental'

  # connection model class
  mattr_accessor :connection_model
  @@connection_model = 'BookingsyncPortal::Connection'

  # photo model class
  mattr_accessor :photo_model
  @@photo_model = 'BookingsyncPortal::Photo'

  # availability model class
  mattr_accessor :availability_model
  @@availability_model = 'BookingsyncPortal::Availability'

  # rate model class
  mattr_accessor :rate_model
  @@rate_model = 'BookingsyncPortal::Rate'

  # account resource class
  mattr_accessor :account_resource
  @@account_resource = 'BookingsyncPortal::AdminApi::AccountResource'

  # remote account resource class
  mattr_accessor :remote_account_resource
  @@remote_account_resource = 'BookingsyncPortal::AdminApi::RemoteAccountResource'

  # rental resource class
  mattr_accessor :rental_resource
  @@rental_resource = 'BookingsyncPortal::AdminApi::RentalResource'

  # remote rental resource class
  mattr_accessor :remote_rental_resource
  @@remote_rental_resource = 'BookingsyncPortal::AdminApi::RemoteRentalResource'

  # connection resource class
  mattr_accessor :connection_resource
  @@connection_resource = 'BookingsyncPortal::AdminApi::ConnectionResource'

  # handle synchronization of rentals after connection is made
  def self.connection_created(connection)
  end

  # handle synchronization of rentals after connection is destroyed
  def self.connection_destroyed(connection)
  end

  # fetch remote rentals
  def self.fetch_remote_rentals(account)
    # return false if remote account is not present or not valid
  end

  # Default way to setup BookingsyncPortal. Run rails generate bookingsync_portal:install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
  end
end
