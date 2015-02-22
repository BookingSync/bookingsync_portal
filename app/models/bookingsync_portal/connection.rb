class BookingsyncPortal::Connection < ActiveRecord::Base
  self.table_name = 'connections'

  belongs_to :remote_rental, class_name: '::RemoteRental'
  belongs_to :rental, class_name: '::Rental'

  validates :remote_rental, presence: true
  validates :rental, presence: true

  validate :ensure_same_ownership_for_rental_and_remote_rental

  private

  def ensure_same_ownership_for_rental_and_remote_rental
    return unless rental && remote_rental
    unless rental.account_id == remote_rental.account.id
      errors.add(:base, I18n.t("errors.messages.different_owner_on_rental_associations"))
    end
  end
end
