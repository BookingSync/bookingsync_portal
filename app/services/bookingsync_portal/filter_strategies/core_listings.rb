class BookingsyncPortal::FilterStrategies::CoreListings < BookingsyncPortal::FilterStrategies::BaseStrategy
  filtered_models BookingsyncPortal.core_listing_model

  def call
    BookingsyncPortal::Searcher.call(
      query: search_filter.core_listings_query,
      records: records,
      search_settings: BookingsyncPortal.core_listings_search_fields
    )
  end
end
