class BookingsyncPortal::FilterStrategies::ChannelListingSections < BookingsyncPortal::FilterStrategies::BaseStrategy
  filtered_models BookingsyncPortal.channel_listing_section_model

  def call
    BookingsyncPortal::Searcher.call(
      query: search_filter.channel_listings_query,
      records: records,
      search_settings: BookingsyncPortal.channel_listing_sections_search_fields
    )
  end
end
