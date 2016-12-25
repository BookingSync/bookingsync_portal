# master

* Add support for Rails 5
* Properly display surface units in connected rentals container

# 0.8.8

* Fix booking map maximum length

# 0.8.7

* Update source spec to test downcased names comparison

# 0.8.6

* Compare source names as downcased strings

# 0.8.5

* Fix rentals partial translations

# 0.8.4

* Introduce BookingMap class for map generation, diffing and range extraction
* Require Ruby 2.1+

# 0.8.3

* Require bookingsync_application 0.4.1 to include webhooks base controller support

# 0.8.2

* Fix threaded routes problems in models. https://github.com/puma/puma/issues/647.

# 0.8.1

* Ensure proper source sync for invalid create remote_accounts calls

# 0.8.0

* Disconnect rentals without reloading page

# 0.7.0

* Remove CircleCI setup
* Cleanup bookingsync_portal config generator and dummy app one
* Add missing dummy simple_form initializer
* Add `BookingsyncPortal.create_remote_rental` option to allow to create remote rentals directly from the app. Default to `false`.
* Refactor connection create and destroy to ConnectionsController.
* Removed portal callbacks after connection create and destroy, should be handle as model callbacks now.
* Refactor connection.js codes. Simplify and cover creating new remote rental case.
* Multiple view, style and js changes around connections. Pay extra attention if an app was extending/overriding them.

# 0.6.0

* Remove json-api leftovers and config options
* Force message bus to use specific channel, as in https://github.com/SamSaffron/message_bus#multisite-support,
  Makes multiple bookingsync_portal applications work in a shared redis setup.

# 0.5.0

* Remove json-api
* Don't setup rates association on rental if not needed
* Bump bookingsync_application to ~ 0.4.0
* Drop ruby 2.0 support

# 0.4.0

* Add source_id to `Account` and assign it when app is being installed. See https://github.com/BookingSync/bookingsync_portal/wiki/Add-source_id-to-Account to make this work.
* Add help section
* Migrate to a 2 column view

# 0.3.3

* Improve Alerts style within Panels

# 0.3.2

* Properly require 'bootstrap-bookingsync-sass' gem
* Lock sprockets-rails to not conflicting ~> 2.3 version

# 0.3.1

* Minor styling fix

# 0.3.0

* New BookingSync style
* Add a warning to readme about using Rack::Lock with message_bus gem.

# 0.2.0

* Bump bookingsync_application to 0.3.1
* Bump jsonapi-resources to 0.5.4 and fix specs with new syntax
* Globally handle unauthorized ajax calls.
* BREAKING CHANGE: Rename account `synced_key` from `uid` to `synced_id`

# 0.1.2

* Remove validation of uid presence for remote_rental to allow remote creation.
* Add visible scope to allow filtering, add synced_id validations for rental.
* Improve filter input styling with bootstrap.

# 0.1.1

* Order rentals by position to keep order from bookingsync.

# 0.1.0

* Update bookingsync_application

# 0.0.6

* Allow to create multiple remote accounts and display all the remote rentals nicely

# 0.0.5

* Fix all synchronized message when there are no rentals

# 0.0.4

* Fix filtering of rentlas when query was blank

# 0.0.3

* Add admin/rentals/_how_to.html.erb template to allow easy howto customizations.
* Fixed filtering selectors to be less affected by customizations.

# 0.0.2

* Added redirect to remote_accounts#create when no remote account is present.
* Added filtering of rental lists.

# 0.0.1

* First public versioned release.
