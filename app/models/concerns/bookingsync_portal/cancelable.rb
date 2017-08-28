module BookingsyncPortal
  module Cancelable
    extend ActiveSupport::Concern

    included do
      scope :visible, -> { where(canceled_at: nil) }
      scope :not_canceled, -> { where(canceled_at: nil) }
      scope :canceled, -> { where.not(canceled_at: nil) }
    end

    def canceled?
      canceled_at.present?
    end

    def visible?
      !canceled?
    end

    def cancel(time = Time.current)
      update_attribute(:canceled_at, time)
    end

    def restore
      cancel(nil)
    end
  end
end
