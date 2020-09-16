class ListingsRepository
  def initialize(account)
    @account = account
  end

  attr_reader :account
  private :account

  def find_core_listings
    account.rentals.visible.ordered.not_connected
  end

  def available_listings_count
    account.rentals.visible.count
  end

  def find_channel_listings
    account.remote_rentals
      .includes(:remote_account, :rental)
      .order(remote_account_id: :desc, created_at: :desc)
  end

  def find_channel_listing_sections
    account.remote_accounts
      .order(remote_account_id: :desc)
  end

  def find_channel_listing_sections_only_with_listings
    account.remote_accounts.joins(:remote_rentals)
  end

  def find_channel_listing_sections_with_blank_ones_first
    account.remote_accounts.left_outer_joins(:remote_rentals)
      .order("remote_rentals.id DESC NULLS FIRST")
      .select("DISTINCT remote_accounts.*, CASE WHEN remote_rentals.id IS NULL THEN 0 ELSE 1 END AS has_listings")
  end

  def group_channel_listings_by_section(channel_listings)
    channel_listings.group_by(&:remote_account)
  end
end
