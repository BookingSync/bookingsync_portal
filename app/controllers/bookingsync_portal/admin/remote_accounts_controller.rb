module BookingsyncPortal
  module Admin
    class RemoteAccountsController < Admin::BaseHTMLController
      def new
        @new_remote_account = objects.build
      end

      def create
        respond_with @new_remote_account = objects.create(params_remote_account),
          location: admin_rentals_url
      end

      private

      def objects
        current_account.remote_accounts
      end

      def params_remote_account
        params.require(:remote_account).permit(:uid)
      end
    end
  end
end
