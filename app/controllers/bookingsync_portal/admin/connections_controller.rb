module BookingsyncPortal
  module Admin
    class ConnectionsController < Admin::BaseController
      def create
        if remote_account? && BookingsyncPortal.create_remote_rental
          new_remote_rental = BookingsyncPortal.remote_rental_model.constantize.new(remote_account: remote_account)
          @connection = rental.create_connection(remote_rental: new_remote_rental)
        else
          @connection = rental.create_connection(remote_rental: remote_rental)
        end

        respond_to do |wants|
          wants.html { redirect_to admin_rentals_path }
          wants.js
        end
      end

      def destroy
        connection = current_account.connections.find(params[:id]).destroy

        respond_to do |wants|
          wants.html { redirect_to admin_rentals_path }
        end
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
    end
  end
end
