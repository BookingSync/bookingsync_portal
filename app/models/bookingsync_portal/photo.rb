class BookingsyncPortal::Photo < ActiveRecord::Base
  self.table_name = 'photos'

  belongs_to :rental
  has_one    :account, through: :rental

  scope :ordered, -> { order position: :asc }
end
