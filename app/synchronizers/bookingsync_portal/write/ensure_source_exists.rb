class BookingsyncPortal::Write::EnsureSourceExists
  attr_reader :account

  def initialize(account)
    @account = account
  end

  def call
    blank_source? ? update_source : true
  end

  private

  def blank_source?
    account.synced_source_id.blank?
  end

  def update_source
    source = BookingsyncPortal::Write::Source.new(account).synchronize
    account.update!(synced_source_id: source.id)
  end
end
