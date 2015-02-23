require 'bookingsync_application/common_base_controller'

module BookingsyncPortal
  module Admin
    class BaseHTMLController < ApplicationController
      layout 'admin'
      respond_to :html

      include BookingsyncApplication::CommonBaseController

      private

      def messagebus_channel
        "/account-#{current_account.id}"
      end
      helper_method :messagebus_channel
    end
  end
end
