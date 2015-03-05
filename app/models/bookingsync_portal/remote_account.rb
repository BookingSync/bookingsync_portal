class BookingsyncPortal::RemoteAccount < ActiveRecord::Base
  self.table_name = 'remote_accounts'

  belongs_to :account, class_name: BookingsyncPortal.account_model
  has_many :remote_rentals, class_name: BookingsyncPortal.remote_rental_model, dependent: :destroy

  validates :uid, presence: true, uniqueness: true
  validates :account, presence: true
end
