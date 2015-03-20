class BookingsyncPortal::Account < ActiveRecord::Base
  self.table_name = 'accounts'

  include BookingSync::Engine::Model

  has_many :remote_accounts, class_name: BookingsyncPortal.remote_account_model, dependent: :destroy
  has_many :remote_rentals, class_name: BookingsyncPortal.remote_rental_model, through: :remote_accounts
  has_many :rentals, class_name: BookingsyncPortal.rental_model, dependent: :destroy
  has_many :connections, class_name: BookingsyncPortal.connection_model, through: :rentals
end
