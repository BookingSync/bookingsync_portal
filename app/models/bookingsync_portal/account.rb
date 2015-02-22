class BookingsyncPortal::Account < ActiveRecord::Base
  self.table_name = 'accounts'

  include BookingSync::Engine::Model

  has_many :remote_accounts, class_name: '::RemoteAccount'
  has_many :rentals, class_name: '::Rental'
  has_many :remote_rentals, through: :remote_accounts, class_name: '::RemoteRental'
  has_many :connections, through: :rentals, class_name: '::Connection'
end
