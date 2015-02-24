module BookingsyncPortal
  class Engine < ::Rails::Engine
    isolate_namespace BookingsyncPortal
    config.generators do |g|
      g.install :install
    end
  end
end
