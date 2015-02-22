class BookingsyncPortal::RemoteRental < ActiveRecord::Base
  self.table_name = 'remote_rentals'

  belongs_to :remote_account, class_name: '::RemoteAccount'
  has_one :account, through: :remote_account, class_name: '::Account'
  has_one :connection, class_name: '::Connection'
  has_one :rental, through: :connection, class_name: '::Rental'

  serialize :remote_data, MashSerializer

  validates :uid, presence: true, uniqueness: true
  validates :remote_account, presence: true
end
