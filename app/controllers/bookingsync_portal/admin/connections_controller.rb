module BookingsyncPortal
  module Admin
    class ConnectionsController < Admin::BaseController
      def create
        if remote_account? && BookingsyncPortal.create_remote_rental_from_app
          new_remote_rental = BookingsyncPortal.remote_rental_model.constantize.new(remote_account: remote_account)
          connection = BookingsyncPortal.connection_model.constantize.create(rental: rental, remote_rental: new_remote_rental)

          BookingsyncPortal.remote_rental_created(new_remote_rental)
          BookingsyncPortal.connection_created(connection)
        else
          connection = rental.create_connection(remote_rental: remote_rental)

          BookingsyncPortal.connection_created(connection)
        
        end

        redirect_or_js_response
      end

      def destroy
        connection = current_account.connections.find(params[:id])
        connection.remote_rental.update_attribute(:synchronized_at, nil)
        connection.destroy

        BookingsyncPortal.connection_destroyed(connection)

        redirect_or_js_response
      end

      private

      def rental
        @rental ||= current_account.rentals.not_connected.visible.find(params[:rental_id])
      end

      def remote_rental
        @remote_rental ||= current_account.remote_rentals.not_connected.find(params[:remote_rental_id])
      end

      def remote_account
        @remote_account ||= current_account.remote_accounts.find(params[:remote_account_id])
      end

      def remote_account?
        params[:remote_account_id].present? && remote_account
      end

      def redirect_or_js_response
        respond_to do |wants|
          wants.html { redirect_to admin_rentals_path }
          wants.js { head :ok }
        end
      end
    end
  end
end
