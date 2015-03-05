require 'rails/generators'

module BookingsyncPortal
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)

      desc "Creates a BookingsyncPortal initializer."

      def copy_initializer
        template "bookingsync_portal.rb", "config/initializers/bookingsync_portal.rb"
      end
    end
  end
end