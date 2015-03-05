require 'rails_helper'

RSpec.describe BookingsyncPortal.account_model.constantize do
  describe 'included_modules' do
    subject { described_class.included_modules }

    it { is_expected.to include BookingSync::Engine::Model }
  end

  it { is_expected.to have_many(:rentals).dependent(:destroy) }
  it { is_expected.to have_many(:remote_accounts).dependent(:destroy) }
  it { is_expected.to have_many(:remote_rentals).through(:remote_accounts) }
  it { is_expected.to have_many(:connections).through(:rentals) }
end
