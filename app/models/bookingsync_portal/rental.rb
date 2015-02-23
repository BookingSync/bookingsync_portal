class BookingsyncPortal::Rental < ActiveRecord::Base
  self.table_name = 'rentals'

  belongs_to :account, class_name: '::Account'
  has_one :connection, class_name: '::Connection', dependent: :destroy
  has_one :remote_rental, class_name: '::RemoteRental', through: :connection
end
