BookingsyncPortal.setup do |config|
  config.message_bus_channel_scope = 'portal_app_name'
  config.source_name = "ExternalPortalAppName".freeze
end
