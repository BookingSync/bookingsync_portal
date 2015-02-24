require 'rails_helper'

RSpec.describe BookingsyncPortal.remote_rental_model.constantize do
  let(:remote_rental) { create :remote_rental }

  it { is_expected.to serialize(:remote_data).as(BookingsyncPortal::MashSerializer) }

  it { is_expected.to belong_to :remote_account }
  it { is_expected.to have_one(:account).through(:remote_account) }
  it { is_expected.to have_one :connection }
  it { is_expected.to have_one(:rental).through(:connection) }

  it { is_expected.to validate_presence_of :uid }
  it { is_expected.to validate_uniqueness_of :uid }
  it { is_expected.to validate_presence_of :remote_account }
end
