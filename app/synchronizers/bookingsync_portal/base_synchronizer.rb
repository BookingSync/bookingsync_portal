module BookingsyncPortal
  class BaseSynchronizer
    attr_reader :scope

    def initialize(options)
      @scope = options[:scope]
    end

    def self.synchronize(options)
      new(options).synchronize
    end

    def synchronize
      raise "implement me"
    end
  end
end
