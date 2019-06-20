module BookingsyncPortal
  module Admin
    module ApplicationHelper
      def rental_details(rental)
        scope = 'bookingsync_portal.admin.rentals.rental'

        details = Array.new
        if rental.sleeps.to_i > 0
          if rental.sleeps_max.to_i > 0 && rental.sleeps_max.to_i > rental.sleeps.to_i
            details << t(:sleeps_html, scope: scope,
              count: "#{rental.sleeps.to_i}-#{rental.sleeps_max.to_i}")
          else
            details << t(:sleeps_html, scope: scope,
              count: rental.sleeps.to_i)
          end
        end
        if rental.bedrooms_count.to_i > 0
          details << t(:bedrooms_html, scope: scope,
            count: rental.bedrooms_count.to_i)
        end
        if rental.bathrooms_count.to_i > 0
          details << t(:bathrooms_html, scope: scope,
            count: rental.bathrooms_count.to_i)
        end
        if rental.surface.to_i > 0
          details << t(:surface_html, scope: scope,
            count: rental.surface.to_i, unit: rental.surface_unit_symbol)
        end

        safe_join(details, ', ')
      end

      def use_paginated_view
        BookingsyncPortal.use_paginated_view.call(current_account)
      end

      def not_connected_rentals_count
        @not_connected_rentals.present? ? @not_connected_rentals.count : 0
      end

      def remote_rentals_count
        @remote_rentals.present? ? @remote_rentals.count : 0
      end
    end
  end
end
