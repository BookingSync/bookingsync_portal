class BookingsyncPortal::Rental < ActiveRecord::Base
  self.table_name = 'rentals'

  belongs_to :account, class_name: '::Account'
end
