class BookingsyncPortal::FilterStrategies::BaseStrategy
  attr_accessor :account, :records, :search_filter
  private :account, :records, :search_filter

  def initialize(account: nil, records:, search_filter:)
    @account = account
    @records = records
    @search_filter = search_filter
  end

  def self.call(account: nil, records:, search_filter: nil)
    return records if models_for_filter.all? {|model_name| model_name.constantize.table_name != records.table_name }
    new(account: account, records: records, search_filter: search_filter).call
  end

  def self.filtered_models(*args)
    @filtered_models = Array.wrap(args)
  end

  def self.models_for_filter
    @filtered_models ||= []
  end
end
