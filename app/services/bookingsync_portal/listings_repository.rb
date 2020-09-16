class BookingsyncPortal::ListingsRepository
  def initialize(account)
    @account = account
  end

  attr_reader :account
  private :account

  def find_core_listings
    raise NotImplementedError
  end

  def available_listings_count
    raise NotImplementedError
  end

  def find_channel_listings
    raise NotImplementedError
  end

  def find_channel_listing_sections
    raise NotImplementedError
  end

  def find_channel_listing_sections_only_with_listings
    raise NotImplementedError
  end

  def find_channel_listing_sections_with_blank_ones_first
    raise NotImplementedError
  end

  def group_channel_listings_by_section(channel_listings)
    raise NotImplementedError
  end
end
