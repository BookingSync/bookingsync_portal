module BookingsyncPortal
  module Admin
    class RentalsController < Admin::BaseController
      before_action :synchronize_rentals, only: :index
      before_action :fetch_remote_rentals, only: :index

      def index
        @not_connected_rentals = current_account.rentals.visible.ordered.not_connected
        @visible_rentals = current_account.rentals.visible
        @remote_accounts = current_account.remote_accounts
        @remote_rentals_by_account = current_account.remote_rentals.ordered
          .includes(:remote_account, :rental).group_by(&:remote_account)
      end

      def show
        rental
      end

      private

      def synchronize_rentals
        BookingsyncPortal.synchronize_rentals.call(current_account)
      end

      def fetch_remote_rentals
        unless BookingsyncPortal.fetch_remote_rentals(current_account)
          @remote_account_not_registered = true
        end
      end

      def rental
        @rental ||= current_account.rentals.visible.find(params[:id])
      end
    end
  end
end
