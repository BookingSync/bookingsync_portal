require 'bookingsync_portal/mash_serializer'

class BookingsyncPortal::RemoteRental < ActiveRecord::Base
  self.table_name = 'remote_rentals'

  belongs_to :remote_account, class_name: BookingsyncPortal.remote_account_model
  has_one :account, class_name: BookingsyncPortal.account_model, through: :remote_account
  has_one :connection, class_name: BookingsyncPortal.connection_model, dependent: :destroy
  has_one :rental, class_name: BookingsyncPortal.rental_model, through: :connection

  serialize :remote_data, BookingsyncPortal::MashSerializer

  validates :uid, uniqueness: { allow_nil: true }
  validates :remote_account, presence: true

  scope :ordered, -> { order(created_at: :desc) }
  scope :connected, -> { joins(:rental) }
  scope :not_connected, -> { includes(:rental).where(rentals: { id: nil }) }

  def connected?
    rental.present?
  end

  def synchronized?
    synchronized_at.present?
  end
end
