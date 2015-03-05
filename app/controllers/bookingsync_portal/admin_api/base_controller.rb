module BookingsyncPortal
  module AdminApi
    class BaseController < BookingsyncApplication::Admin::BaseController

      private

      def messagebus_channel
        "/account-#{current_account.id}"
      end
      helper_method :messagebus_channel
    end
  end
end
