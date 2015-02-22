require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'included_modules' do
    subject { described_class.included_modules }

    it { is_expected.to include BookingSync::Engine::Model }
  end

  it { is_expected.to have_many :rentals }
  it { is_expected.to have_many :remote_accounts }
  it { is_expected.to have_many(:remote_rentals).through(:remote_accounts) }
  it { is_expected.to have_many(:connections).through(:rentals) }
end
