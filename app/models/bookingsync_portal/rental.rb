class BookingsyncPortal::Rental < ActiveRecord::Base
  self.table_name = 'rentals'

  belongs_to :account, class_name: BookingsyncPortal.account_model
  has_one    :connection, class_name: BookingsyncPortal.connection_model, dependent: :destroy
  has_one    :remote_rental, class_name: BookingsyncPortal.remote_rental_model, through: :connection
  has_many   :photos, class_name: BookingsyncPortal.photo_model, dependent: :destroy
  if BookingsyncPortal.rate_model.present?
    has_many   :rates, class_name: BookingsyncPortal.rate_model, dependent: :destroy
  end

  validates :synced_id, uniqueness: true, presence: true

  scope :ordered, -> { order(position: :asc) }
  scope :connected, -> { joins(:remote_rental) }
  scope :not_connected, -> { includes(:connection).where(connections: { remote_rental_id: nil }) }
  scope :visible, -> { all }

  def connected?
    remote_rental.present?
  end

  def ordered_photos
    photos.ordered
  end
end
