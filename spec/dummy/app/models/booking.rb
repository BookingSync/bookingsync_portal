class Booking < ActiveRecord::Base
  validates :start_at, presence: true
  validates :end_at, presence: true
  validates :status, presence: true
end
