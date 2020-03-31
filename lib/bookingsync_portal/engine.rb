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

    initializer "webpacker.proxy" do |app|
      insert_middleware = begin
                          BookingsyncPortal.webpacker.config.dev_server.present?
                        rescue
                          nil
                        end
      next unless insert_middleware

      app.middleware.insert_before(
        0, Webpacker::DevServerProxy,
        ssl_verify_none: true,
        webpacker: BookingsyncPortal.webpacker
      )
    end
  end
end
