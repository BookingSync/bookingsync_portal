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

  # UI related models
  # Core listing model class. This data model is used to render rentals which are not connected yet
  mattr_accessor :core_listing_model
  @@core_listing_model = 'BookingsyncPortal::Rental'

  # Channel listing model class. This data model is used to render already connected rentals
  # Basically there is a connection data model which links rental from core and rental from channel.
  # You should specify here the data model which stores rentals from the channel
  mattr_accessor :channel_listing_model
  @@channel_listing_model = 'BookingsyncPortal::RemoteRental'

  # Channel listing section model class. Listings on the right side are grouped sometimes by a property or
  # by the remote account. This is a general entity that acts in UI as a wrapper for channel listings
  mattr_accessor :channel_listing_section_model
  @@channel_listing_section_model = 'BookingsyncPortal::RemoteAccount'

  # This is an entry to all initial database queries. Basically all methods return ActiveRecord::Relation
  # object so it is easy to leak a bit and use it further (like in apply_pagination or apply_search methods)
  #
  # Example:
  #   BookingsyncPortal.listings_repository_proc.call(account).find_core_listings
  mattr_accessor :listings_repository_proc
  @@listings_repository_proc = ->(account) { BookingsyncPortal::ListingsRepository.new(account) }

  # whether load-all (false) or paginated (true) view should be used for admin#index
  mattr_accessor :use_paginated_view
  @@use_paginated_view = -> (_account) { false }

  # search fields for core listings
  mattr_accessor :core_listings_search_fields
  @@core_listings_search_fields = {
    numeric: %w(synced_id),
    string: %w(name)
  }

  # search fields for channel listings
  mattr_accessor :channel_listings_search_fields
  @@channel_listings_search_fields = {
    numeric: %w(uid remote_account.uid),
    string: %w(rental.name)
  }

  # search fields for channel listing sections
  mattr_accessor :channel_listing_sections_search_fields
  @@channel_listing_sections_search_fields = {
    numeric: %w(uid)
  }

  mattr_accessor :filter_strategies
  @@filter_strategies = [
    "BookingsyncPortal::FilterStrategies::CoreListings",
    "BookingsyncPortal::FilterStrategies::ChannelListings",
    "BookingsyncPortal::FilterStrategies::ChannelListingSections"
  ]

  # the number of listings that will be displayed per page
  # works only with enabled use_paginated_view
  mattr_accessor :items_per_page
  @@items_per_page = 25

  mattr_accessor :before_rentals_index_action_filter
  @@before_rentals_index_action_filter = -> (_controller) { }

  mattr_accessor :after_rentals_index_action_filter
  @@after_rentals_index_action_filter = -> (_controller) { }

  # message bus channel scope
  mattr_accessor :message_bus_channel_scope

  # is it required to sync listings before showing them
  mattr_accessor :should_synchronize_core_listings
  @@should_synchronize_core_listings = true

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
