require 'bookingsync_portal/mash_serializer'

class BookingsyncPortal::RemoteRental < ActiveRecord::Base
  self.table_name = 'remote_rentals'

  belongs_to :remote_account, class_name: BookingsyncPortal.remote_account_model
  has_one :account, through: :remote_account, class_name: BookingsyncPortal.account_model
  has_one :connection, class_name: BookingsyncPortal.connection_model
  has_one :rental, through: :connection, class_name: BookingsyncPortal.rental_model

  serialize :remote_data, BookingsyncPortal::MashSerializer

  validates :uid, presence: true, uniqueness: true
  validates :remote_account, presence: true
end
