module BookingsyncPortal
  module AdminApi
    class RemoteRentalsController < BookingsyncPortal::AdminApi::BaseController
      prepend_before_action :set_resource_klass_name
      before_action :fetch_remote_rentals, only: :index

      private

      def fetch_remote_rentals
        BookingsyncPortal.fetch_remote_rentals(current_account)
      end

      def set_resource_klass_name
        @resource_klass_name = BookingsyncPortal.remote_rental_resource
      end
    end
  end
end
