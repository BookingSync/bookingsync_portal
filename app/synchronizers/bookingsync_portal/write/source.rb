class BookingsyncPortal::Write::Source
  attr_reader :account
  private :account

  def initialize(account)
    @account = account
  end

  def synchronize
    find_or_create
  end

  private

  def find_or_create
    find_source || create_source
  end

  def api
    account.api
  end

  def find_source
    api.sources.find { |s| s.name == BookingsyncPortal.source_name }
  end

  def create_source
    api.create_source(name: BookingsyncPortal.source_name)
  end
end
