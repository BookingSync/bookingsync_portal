$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bookingsync_portal/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "bookingsync_portal"
  s.version     = BookingsyncPortal::VERSION
  s.authors     = ["Piotr Marciniak"]
  s.email       = ["mandaryyyn@gmail.com"]
  s.homepage    = "https://github.com/BookingSync/bookingsync_portal"
  s.summary     = "A common base for creating BookingSync portal applications."
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"
  s.add_dependency "bookingsync_application"

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency "sqlite3"
end
