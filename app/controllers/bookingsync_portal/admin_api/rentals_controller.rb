module BookingsyncPortal
  module AdminApi
    class RentalsController < BookingsyncPortal::AdminApi::BaseController
      prepend_before_action :set_resource_klass_name
      before_action :synchronize_rentals, only: :index

      private

      def synchronize_rentals
        BookingsyncPortal.rental_model.constantize.synchronize(scope: current_account)
      end

      def set_resource_klass_name
        @resource_klass_name = BookingsyncPortal.rental_resource
      end
    end
  end
end
