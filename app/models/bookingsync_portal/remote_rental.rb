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
  scope :connected, -> { joins(:rental).where(connections: { canceled_at: nil }) }
  scope :not_connected, -> {
    includes(:rental)
      .where("connections.canceled_at IS NOT NULL OR rentals.id IS NULL")
      .references(:rental)
  }

  def display_name
    uid
  end

  def connected?
    rental.present? && connection.visible?
  end

  def connection_canceled?
    rental.present? && connection.canceled?
  end

  def synchronized?
    synchronized_at.present?
  end
end
