$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'bookingsync_portal/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'bookingsync_portal'
  s.version     = BookingsyncPortal::VERSION
  s.authors     = ['Piotr Marciniak', 'Sebastien Grosjean', 'Artur Krzeminski Freda']
  s.email       = ['mandaryyyn@gmail.com', 'dev@bookingsync.com', 'artur@bookingsync.com']
  s.homepage    = 'https://github.com/BookingSync/bookingsync_portal'
  s.summary     = 'A common base for creating BookingSync portal applications.'
  s.description = 'A common base for creating BookingSync portal applications.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '>= 5.2'
  s.add_dependency 'sprockets-rails'
  s.add_dependency 'sprockets', '>= 4'
  s.add_dependency 'responders'
  s.add_dependency 'bookingsync_application', ['>= 4', '< 5']
  s.add_dependency 'redis'
  # FIXME: Will no longer be needed once UI moved to Ember
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-ui-rails', '~> 6.0.1'
  s.add_dependency 'bootstrap-sass', '< 3.5'
  s.add_dependency 'bootstrap-bookingsync-sass', '~> 2.0.0'
  s.add_dependency 'font-awesome-sass', '4.7.0'
  s.add_dependency 'handlebars_assets'
  s.add_dependency 'simple_form'
  s.add_dependency 'message_bus'
  s.add_dependency 'turbolinks'
  s.add_dependency 'sass-rails'
  s.add_dependency 'uglifier'
  s.add_dependency 'coffee-rails'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda-matchers', '>= 4'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'sqlite3', '~> 1.4'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'pry-rails'
  s.add_development_dependency 'rails-controller-testing'
end
