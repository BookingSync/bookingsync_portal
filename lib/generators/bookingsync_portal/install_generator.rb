require 'rails/generators'

module BookingsyncPortal
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a BookingsyncPortal initializer and default models."

      def copy_initializer
        template "initializers/bookingsync_portal.rb", "config/initializers/bookingsync_portal.rb"
        template "models/account.rb", "app/models/account.rb"
        template "models/connection.rb", "app/models/connection.rb"
        template "models/photo.rb", "app/models/photo.rb"
        template "models/rate.rb", "app/models/rate.rb"
        template "models/remote_account.rb", "app/models/remote_account.rb"
        template "models/remote_rental.rb", "app/models/remote_rental.rb"
        template "models/rental.rb", "app/models/rental.rb"
      end
    end
  end
end
