class BookingsyncPortal::Rental < ActiveRecord::Base
  self.table_name = 'rentals'

  belongs_to :account, class_name: BookingsyncPortal.account_model
  has_one :connection, class_name: BookingsyncPortal.connection_model, dependent: :destroy
  has_one :remote_rental, class_name: BookingsyncPortal.remote_rental_model, through: :connection
end
