require 'rails_helper'

RSpec.describe BookingsyncPortal.rental_model.constantize do
  it { is_expected.to belong_to(:account) }
  it { is_expected.to have_one(:connection).dependent(:destroy) }
  it { is_expected.to have_one(:remote_rental).through(:connection) }

  describe '#connected?' do
    subject { rental.connected? }
    context 'when rental present' do
      let(:rental) { build(:rental, remote_rental: build(:remote_rental)) }
      it { is_expected.to eq(true) }
    end

    context 'when rental nil' do
      let(:rental) { build(:rental, remote_rental: nil) }
      it { is_expected.to eq(false) }
    end
  end
end
