class BookingsyncPortal::SearchFilter
  attr_reader :params
  def initialize(params)
    @params = params
  end

  def rentals_query
    @rentals_query ||= params.dig(:rentals_search, :query).to_s.strip
  end

  def remote_rentals_query
    @remote_rentals_query ||= params.dig(:remote_rentals_search, :query).to_s.strip
  end

  def rentals_page
    @rentals_page ||= [params.dig(:rentals_search, :page).to_i, 1].max
  end

  def remote_rentals_page
    @remote_rentals_page ||= [params.dig(:remote_rentals_search, :page).to_i, 1].max
  end
end

