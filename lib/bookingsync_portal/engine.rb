module BookingsyncPortal
  class Engine < ::Rails::Engine
    engine_name 'bookingsync_portal'
    isolate_namespace BookingsyncPortal
    config.generators do |g|
      g.install :install
    end
  end
end
