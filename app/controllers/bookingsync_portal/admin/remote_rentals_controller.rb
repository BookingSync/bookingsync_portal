module BookingsyncPortal
  module Admin
    class RemoteRentalsController < Admin::BaseController
      before_action :synchronize_remote_rentals

      def synchronize_remote_rentals
        Read::RemoteRental.synchronize(scope: current_account)
      end
    end
  end
end
