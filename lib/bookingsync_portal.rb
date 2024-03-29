require 'bookingsync_application'
require 'bookingsync_portal/engine'
require 'bookingsync_portal/mash_serializer'
require 'bookingsync_portal/booking_map'
require 'message_bus'

# FIXME requires below should get removed when ember frontend is added
require 'uglifier'
require 'coffee-rails'
require 'sass-rails'
require 'bootstrap-bookingsync-sass'
require 'jquery-rails'
require 'jquery-ui-rails'
require 'font-awesome-sass'
require 'handlebars_assets'
require 'simple_form'
require 'turbolinks'
require 'responders'

module BookingsyncPortal
  # portal name
  mattr_accessor :portal_name
  @@portal_name = 'Portal'

  # source name for use in bookings
  mattr_accessor :source_name

  # Allow to create a remote rental from this app.
  mattr_accessor :create_remote_rental
  @@create_remote_rental = false

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

  # rate model class
  mattr_accessor :rate_model
  @@rate_model = 'BookingsyncPortal::Rate'

  # message bus channel scope
  mattr_accessor :message_bus_channel_scope

  # Define if/how to pre-synchronize rentals before rendering index page. Default is inline sync using synced gem
  mattr_accessor :rentals_synchronizer
  @@rentals_synchronizer = ->(account) { BookingsyncPortal.rental_model.constantize.synchronize(scope: account) }

  # fetch remote rentals
  def self.fetch_remote_rentals(account)
    # return false if remote account is not present or not valid
  end

  # Default way to setup BookingsyncPortal. Run rails generate bookingsync_portal:install to create
  # a fresh initializer with all configuration values.
  def self.setup
    yield self
    raise ArgumentError.new("message_bus_channel_scope must be defined") unless message_bus_channel_scope.present?
    ::MessageBus.site_id_lookup do
      message_bus_channel_scope
    end
  end
end
