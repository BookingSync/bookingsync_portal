module BookingsyncPortal
  class Engine < ::Rails::Engine
    engine_name 'bookingsync_portal'
    isolate_namespace BookingsyncPortal
    config.generators do |g|
      g.install :install
    end

    if defined?(Sprockets) && Sprockets::VERSION.chr.to_i >= 3
      initializer 'bookingsync_portal.assets.precompile' do |app|
        app.config.assets.precompile += %w(
          bookingsync_portal/help/connect.gif
          bookingsync_portal/bookingsync.png
        )
      end
    end
  end
end
