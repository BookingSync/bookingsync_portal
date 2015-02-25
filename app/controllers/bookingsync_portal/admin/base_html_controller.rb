require 'bookingsync_application/admin/common_base_controller'

module BookingsyncPortal
  module Admin
    class BaseHTMLController < ApplicationController
      layout 'admin'
      respond_to :html

      include BookingsyncApplication::Admin::CommonBaseController

      private

      def messagebus_channel
        "/account-#{current_account.id}"
      end
      helper_method :messagebus_channel
    end
  end
end
