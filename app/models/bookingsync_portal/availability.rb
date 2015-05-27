class BookingsyncPortal::Availability < ActiveRecord::Base
  self.table_name = 'availabilities'

  belongs_to :rental
  has_one    :account, through: :rental
end
