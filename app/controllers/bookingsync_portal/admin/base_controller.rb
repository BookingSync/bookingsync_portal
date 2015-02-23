module BookingsyncPortal
  module Admin
    class BaseController < BookingsyncApplication::Admin::BaseController
      layout 'admin'

      private

      def messagebus_channel
        "/account-#{current_account.id}"
      end
      helper_method :messagebus_channel
    end
  end
end