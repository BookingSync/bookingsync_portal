module BookingsyncPortal
  module Admin
    class RemoteAccountsController < Admin::BaseController
      skip_before_action :enforce_remote_account!

      def new
        @remote_account = scope.build
      end

      def create
        @remote_account = scope.create(params_remote_account)
        respond_with @remote_account, location: admin_rentals_url
      end

      private

      def scope
        current_account.remote_accounts
      end

      def params_remote_account
        params.require(:remote_account).permit(:uid)
      end
    end
  end
end
