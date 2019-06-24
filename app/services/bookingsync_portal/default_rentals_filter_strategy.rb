class BookingsyncPortal::DefaultRentalsFilterStrategy
  def self.call(records:, search_filter:)
    return records if records.table_name != "rentals"
    BookingsyncPortal::Searcher.call(query: search_filter.rentals_query, records: records, search_settings: BookingsyncPortal.rentals_search)
  end
end
