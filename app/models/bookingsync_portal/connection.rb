class BookingsyncPortal::Connection < ActiveRecord::Base
  self.table_name = 'connections'

  belongs_to :remote_rental, class_name: '::RemoteRental'
  belongs_to :rental, class_name: '::Rental'

  validates :remote_rental, presence: true
  validates :rental, presence: true

  validate :matching_accounts, if: -> { rental && remote_rental }

  private

  def matching_accounts?
    rental.account_id == remote_rental.account.id
  end

  def matching_accounts
    errors.add(:base, :not_matching_accounts) unless matching_accounts?
  end
end
