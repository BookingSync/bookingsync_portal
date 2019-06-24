module BookingsyncPortal
  module FilterStrategies
    class RemoteRentals  < BaseStrategy
      filtered_models BookingsyncPortal.remote_rental_model

      def call
        BookingsyncPortal::Searcher.call(query: search_filter.remote_rentals_query, records: records, search_settings: BookingsyncPortal.remote_rentals_search)
      end
    end
  end
end
