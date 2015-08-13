[![Code Climate](https://codeclimate.com/github/BookingSync/bookingsync_portal/badges/gpa.svg)](https://codeclimate.com/github/BookingSync/bookingsync_portal)
[![Build Status](https://travis-ci.org/BookingSync/bookingsync_portal.svg?branch=master)](https://travis-ci.org/BookingSync/bookingsync_portal)

# BookingsyncPortal

A Rails engine to simplify building BookingSync Portal Applications.

## Requirements

This engine requires Rails `>= 4.0.0` and Ruby `>= 2.0.0`.

## Documentation

[API documentation is available at rdoc.info](http://rdoc.info/github/BookingSync/bookingsync_portal/master/frames).

## Installation

BookingSync Portal works with Rails 4.0 onwards and Ruby 2.0 onwards. To get started, add it to your Gemfile with:

```ruby
gem 'bookingsync_portal'
```

Then bundle install:

```ruby
bundle install
```

### Add routes

BookingSync Authorization routes need to be mounted inside you apps `routes.rb`:

```ruby
mount BookingSync::Engine => '/'
```

This will add the following routes:

* `/auth/bookingsync/callback`
* `/auth/failure`
* `/signout`

as well as BookingSync Portal controllers routes:

```ruby
mount BookingsyncPortal::Engine => '/'
```

### Migrations

BookingSync Portal provide migrations for the most common models:
* `Account`: BookingSync accounts,
* `Connection`: connection between `rentals` and `remote_rentals`,
* `Photo`: BookingSync rentals' photos,
* `Rate`: BookingSync rentals' rates,
* `RemoteAccount`: Portal accounts,
* `RemoteRental`: Portal rentals,
* `Rental`: BookingSync rentals,

You can copy the migrations file to your application by running:

```console
rake bookingsync_portal:install:migrations
```

then run the migration:

```console
rake db:migrate
```

### Add initializer and default models

This will install a configuration file in `config/initializers/bookingsync_portal.rb` as well as creating default models:

```console
rails g bookingsync_portal:install
```


### Assets

You will need to install the assets for each namespace:

in `/app/assets/javascripts/admin/application.js`:

```javascript
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require bookingsync_portal/admin/application
//= require_tree .
```

in `/app/assets/javascripts/admin/application.css.scss`:

```scss
/*
 * This is a manifest file that'll be compiled into application.css, which will include all the files
 * listed below.
 *
 * Any CSS and SCSS file within this directory, lib/assets/stylesheets, vendor/assets/stylesheets,
 * or vendor/assets/stylesheets of plugins, if any, can be referenced here using a relative path.
 *
 * You're free to add application-wide styles to this file and they'll appear at the bottom of the
 * compiled file so the styles you add here take precedence over styles defined in any styles
 * defined in the other CSS/SCSS files in this directory. It is generally better to create a new
 * file per style scope.
 *
 *= require bookingsync_portal/admin/application
 *= require_self
 */

```


_Note: When saving new token, this gem uses a separate thread with new db connection to ensure token save (in case of a rollback in the main transaction). To make room for the new connections, it is recommended to increase db `pool` size by 2-3._

## Configuration

The engine is configured by the following ENV variables:

* `BOOKINGSYNC_URL` - the url of the website, should be `https://www.bookingsync.com`
* `BOOKINGSYNC_APP_ID` - BookingSync Application's Client ID
* `BOOKINGSYNC_APP_SECRET` - BookingSync Application's Client Secret
* `BOOKINGSYNC_VERIFY_SSL` - Verify SSL (available only in development or test). Default to false
* `BOOKINGSYNC_SCOPE` - Space separated list of required scopes. Defaults to nil, which means the public scope.

You might want to use [dotenv-rails](https://github.com/bkeepers/dotenv)
to make ENV variables management easy.

Rack::Lock is not recommended with message_bus gem, causing deadlock problems. You might want to add this line to your app `development.rb` file:

```ruby
config.middleware.delete Rack::Lock
```

## Testing

### RSpec

We do provide some helper for RSpec users, you can include them in your `spec/rails_helper.rb` (before `spec/support` inclusion):
```
require 'bookingsync_application/spec_helper'
```

### VCR

We recommend a VCR setup inspired from the following configuration. It will mask authorization tokens from your fixtures:

```ruby
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.filter_sensitive_data('BOOKINGSYNC_OAUTH_ACCESS_TOKEN') do
    ENV['BOOKINGSYNC_OAUTH_ACCESS_TOKEN']
  end
  # Uncomment if using codeclimate
  # config.ignore_hosts 'codeclimate.com'
end
```
