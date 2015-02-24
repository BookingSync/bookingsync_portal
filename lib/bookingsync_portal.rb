require 'bookingsync_application'
require 'bookingsync_portal/engine'

module BookingsyncPortal
  #customizeable classes with accessor name and default class, simplifies extending engine functionality
  CUSTOMIZEABLE_CLASSES = {
    account_model: 'BookingsyncPortal::Account',
    remote_account_model: 'BookingsyncPortal::RemoteAccount',
    rental_model: 'BookingsyncPortal::Rental',
    remote_rental_model: 'BookingsyncPortal::RemoteRental',
    connection_model: 'BookingsyncPortal::Connection'
  }

  CUSTOMIZEABLE_CLASSES.each do |method_name, default_value|
    mattr_writer method_name
    singleton_class.instance_eval do
      define_method(method_name) { class_variable_get("@@#{method_name}") || default_value }
    end
  end
end
