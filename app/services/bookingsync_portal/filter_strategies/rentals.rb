module BookingsyncPortal
  module FilterStrategies
    class Rentals < BaseStrategy
      filtered_models BookingsyncPortal.rental_model

      def call
        BookingsyncPortal::Searcher.call(query: search_filter.rentals_query, records: records, search_settings: BookingsyncPortal.rentals_search)
      end
    end
  end
end
