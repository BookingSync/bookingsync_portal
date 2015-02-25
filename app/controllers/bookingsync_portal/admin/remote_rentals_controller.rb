module BookingsyncPortal
  module Admin
    class RemoteRentalsController < Admin::BaseController
      prepend_before_action :set_resource_klass_name
      before_action :fetch_remote_rentals

      def fetch_remote_rentals
        BookingsyncPortal::Callbacks.fetch_remote_rentals(current_account)
      end

      def set_resource_klass_name
        @resource_klass_name = BookingsyncPortal.remote_rental_resource
      end
    end
  end
end
