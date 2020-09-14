class BookingsyncPortal::DefaultRentalsFilterStrategy
  def self.call(records:, search_filter:)
    return records if records.table_name != BookingsyncPortal.core_listing_model.constantize.table_name

    BookingsyncPortal::Searcher.call(
      query: search_filter.core_listings_query,
      records: records,
      search_settings: BookingsyncPortal.core_listings_search
    )
  end
end
