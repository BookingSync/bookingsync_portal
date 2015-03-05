class BookingsyncPortal::RemoteAccount < ActiveRecord::Base
  self.table_name = 'remote_accounts'

  belongs_to :account, class_name: BookingsyncPortal.account_model
  has_many :remote_rentals, dependent: :destroy, class_name: BookingsyncPortal.remote_rental_model

  validates :uid, presence: true, uniqueness: true
  validates :account, presence: true
end
