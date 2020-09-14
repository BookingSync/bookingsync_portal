class BookingsyncPortal::Searcher
  def self.call(query:, search_settings:, records:)
    return records if query.blank?
    return records if search_settings.blank?

    conditions = { m: "or" }

    search_settings.each do |type, filtered_fields|
      filtered_fields.each do |field|
        conditions.merge!(build_search_query(type, field.gsub(".", "_"), query))
      end
    end

    records.ransack(conditions).result
  end

  private

  def self.build_search_query(type, field, query)
    if type == :string
      { "#{field}_cont" => query }
    else
      { "#{field}_eq" => query }
    end
  end
end
