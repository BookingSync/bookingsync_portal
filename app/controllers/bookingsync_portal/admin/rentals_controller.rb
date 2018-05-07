module BookingsyncPortal
  module Admin
    class RentalsController < Admin::BaseController
      before_action :synchronize_rentals, only: :index
      before_action :fetch_remote_rentals, only: :index

      def index
        @not_connected_rentals = not_connected_rentals.call
        @visible_rentals = visible_rentals.call
        @remote_accounts = remote_account.call
        @remote_rentals_by_account = remote_rentals_by_account.call
      end

      def show
        rental
      end

      private

      def not_connected_rentals
        BookingsyncPortal.not_connected_rentals || Proc.new { current_account.rentals.visible.ordered.not_connected }
      end
      
      def visible_rentals
        BookingsyncPortal.visible_rentals || Proc.new { current_account.rentals.visible }
      end
      
      def remote_account
        BookingsyncPortal.remote_accounts ||  Proc.new { current_account.remote_accounts }
      end
      
      def remote_rentals_by_account
        BookingsyncPortal.remote_rentals_by_account || Proc.new { current_account.remote_rentals.ordered.includes(:remote_account, :rental).group_by(&:remote_account) }
      end

      def synchronize_rentals
        BookingsyncPortal.rental_model.constantize.synchronize(scope: current_account)
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
