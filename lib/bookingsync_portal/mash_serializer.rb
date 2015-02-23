class BookingsyncPortal::MashSerializer
  def self.dump(obj)
    JSON.dump(obj)
  end

  def self.load(data)
    Hashie::Mash.new(JSON.load(data))
  end
end
