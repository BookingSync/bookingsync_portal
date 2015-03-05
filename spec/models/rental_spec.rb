require 'rails_helper'

RSpec.describe BookingsyncPortal.rental_model.constantize do
  it { is_expected.to belong_to :account }
  it { is_expected.to have_one(:connection).dependent(:destroy) }
  it { is_expected.to have_one(:remote_rental).through(:connection) }
end
