class BookingsyncPortal::SearchFilter
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def core_listings_query
    @core_listings_query ||= params.dig(:core_listings_search, :query).to_s.strip
  end

  def channel_listings_query
    @channel_listings_query ||= params.dig(:channel_listings_search, :query).to_s.strip
  end

  def core_listings_page
    @core_listings_page ||= [params.dig(:core_listings_search, :page).to_i, 1].max
  end

  def channel_listings_page
    @channel_listings_page ||= [params.dig(:channel_listings_search, :page).to_i, 1].max
  end
end

