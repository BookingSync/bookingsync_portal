module BookingsyncPortal
  module Admin
    class RentalsController < Admin::BaseController
      before_action :synchronize_rentals, only: :index
      before_action :fetch_remote_rentals, only: :index

      def index
        @not_connected_rentals = current_account.rentals.visible.ordered.not_connected
        @visible_rentals_count = current_account.rentals.visible.count
        @remote_accounts = current_account.remote_accounts
        @remote_rentals_by_account = current_account.remote_rentals.ordered
          .includes(:remote_account).group_by(&:remote_account)
      end

      def show
        rental
      end

      def connect
        remote_rental = current_account.remote_rentals.find(params[:remote_rental_id])
        connection = rental.build_connection(remote_rental: remote_rental)
        connection.save

        BookingsyncPortal.connection_created(connection)
        redirect_or_js_response
      end

      def disconnect
        connection = rental.connection
        rental.remote_rental.update_attribute(:synchronized_at, nil)
        connection.destroy

        BookingsyncPortal.connection_destroyed(connection)
        redirect_or_js_response
      end

      private

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

      def redirect_or_js_response
        respond_to do |wants|
          wants.html { redirect_to admin_rentals_path }
          wants.json { head :ok }
        end
      end
    end
  end
end
