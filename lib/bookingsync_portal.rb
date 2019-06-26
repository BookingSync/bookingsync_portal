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
require 'kaminari'
require 'ransack'

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

  # whether load-all (false) or paginated (true) view should be used for admin#index
  mattr_accessor :use_paginated_view
  @@use_paginated_view = -> (_account) { false }

  # search by not connected rentals
  mattr_accessor :rentals_search
  @@rentals_search = {
    numeric: %w(synced_id),
    string: %w(name)
  }
  
  # search by remote rentals rentals
  mattr_accessor :remote_rentals_search
  @@remote_rentals_search = {
    numeric: %w(uid remote_account.uid),
    string: %w(rental.name)
  }

  mattr_accessor :filter_strategies
  @@filter_strategies = [
    "BookingsyncPortal::FilterStrategies::Rentals",
    "BookingsyncPortal::FilterStrategies::RemoteRentals",
    "BookingsyncPortal::FilterStrategies::BlankRemoteAccounts"
  ]

  # the number of items that will be displayed per page
  # works only with enabled use_paginated_view
  mattr_accessor :items_per_page
  @@items_per_page = 25

  mattr_accessor :extend_rentals_index_action
  @@extend_rentals_index_action = -> (_account, _action_variables, _params) { }

  # included tables for remote_rentals_by_account
  mattr_accessor :remote_rentals_by_account_included_tables
  @@remote_rentals_by_account_included_tables = %w(remote_account rental)

  # message bus channel scope
  mattr_accessor :message_bus_channel_scope

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
