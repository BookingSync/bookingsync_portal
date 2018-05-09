module BookingsyncPortal
  module Admin
    class RentalsController < Admin::BaseController
      before_action :synchronize_rentals, only: :index
      before_action :fetch_remote_rentals, only: :index

      def index
        render :index, locals: { **index_arguments }
      end

      def show
        rental
      end

      def index_arguments
        BookingsyncPortal.custom_arguments.dig("Admin", "RentalsController", "index") || {
          not_connected_rentals: not_connected_rentals.call(current_account),
          visible_rentals: visible_rentals.call(current_account),
          remote_accounts: remote_accounts.call(current_account),
          remote_rentals_by_account: remote_rentals_by_account.call(current_account)
        }
      end

      private

      def not_connected_rentals
        BookingsyncPortal.not_connected_rentals || lambda {
          |account| account.rentals.visible.ordered.not_connected
        }
      end
      
      def visible_rentals
        BookingsyncPortal.visible_rentals || lambda { |account| account.rentals.visible }
      end
      
      def remote_accounts
        BookingsyncPortal.remote_accounts ||  lambda { |account| account.remote_accounts }
      end
      
      def remote_rentals_by_account
        BookingsyncPortal.remote_rentals_by_account || lambda {
          |account| account.remote_rentals.ordered.includes(:remote_account, :rental).group_by(&:remote_account)
        }
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
