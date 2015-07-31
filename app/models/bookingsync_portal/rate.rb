class BookingsyncPortal::Rate < ActiveRecord::Base
  self.table_name = 'rates'

  belongs_to :rental
  has_one    :account, through: :rental
end
