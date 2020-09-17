module BookingsyncPortal
  module Admin
    module ApplicationHelper
      def core_listing_details(core_listing)
        scope = "bookingsync_portal.admin.rentals.core_listing"

        details = []
        if core_listing.sleeps.to_i > 0
          if core_listing.sleeps_max.to_i > 0 && core_listing.sleeps_max.to_i > core_listing.sleeps.to_i
            details << t(:sleeps_html, scope: scope,
              count: "#{core_listing.sleeps.to_i}-#{core_listing.sleeps_max.to_i}")
          else
            details << t(:sleeps_html, scope: scope,
              count: core_listing.sleeps.to_i)
          end
        end
        if core_listing.bedrooms_count.to_i > 0
          details << t(:bedrooms_html, scope: scope,
            count: core_listing.bedrooms_count.to_i)
        end
        if core_listing.bathrooms_count.to_i > 0
          details << t(:bathrooms_html, scope: scope,
            count: core_listing.bathrooms_count.to_i)
        end
        if core_listing.surface.to_i > 0
          unit = t(core_listing.surface_unit, scope: scope + ".surface_unit").html_safe
          details << t(:surface_html, scope: scope,
            count: core_listing.surface.to_i, unit: unit)
        end

        safe_join(details, ", ")
      end

      def use_paginated_view?
        BookingsyncPortal.use_paginated_view.call(current_account)
      end

      def core_listings_count
        @core_listings.present? ? @core_listings.count : 0
      end

      def channel_listings_count
        @channel_listings.present? ? @channel_listings.count : 0
      end
    end
  end
end
