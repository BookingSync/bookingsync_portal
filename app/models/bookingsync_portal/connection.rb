class BookingsyncPortal::Connection < ActiveRecord::Base
  self.table_name = 'connections'

  belongs_to :remote_rental, class_name: BookingsyncPortal.remote_rental_model
  belongs_to :rental, class_name: BookingsyncPortal.rental_model

  validates :remote_rental, presence: true
  validates :rental, presence: true

  validate :matching_accounts, if: -> { rental && remote_rental }

  private

  def matching_accounts?
    rental.account == remote_rental.remote_account.account
  end

  def matching_accounts
    errors.add(:base, :not_matching_accounts) unless matching_accounts?
  end
end
