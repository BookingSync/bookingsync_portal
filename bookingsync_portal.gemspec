$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'bookingsync_portal/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'bookingsync_portal'
  s.version     = BookingsyncPortal::VERSION
  s.authors     = ['Piotr Marciniak']
  s.email       = ['mandaryyyn@gmail.com']
  s.homepage    = 'https://github.com/BookingSync/bookingsync_portal'
  s.summary     = 'A common base for creating BookingSync portal applications.'
  s.description = ''
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails'
  s.add_dependency 'responders', '~> 2.0'
  s.add_dependency 'bookingsync_application', '~> 0.2.0'
  # FIXME: Will no longer be needed once UI moved to Ember
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'bootstrap-sass'
  s.add_dependency 'font-awesome-sass'
  s.add_dependency 'handlebars_assets'
  s.add_dependency 'simple_form'
  s.add_dependency 'message_bus'
  s.add_dependency 'turbolinks'
  s.add_dependency 'sass-rails'
  s.add_dependency 'uglifier'
  s.add_dependency 'coffee-rails'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rubocop'
end
