# master

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
