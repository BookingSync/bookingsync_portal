require 'rails_helper'

RSpec.describe BookingsyncPortal.remote_rental_model.constantize do
  it { is_expected.to serialize(:remote_data).as(BookingsyncPortal::MashSerializer) }

  it { is_expected.to belong_to(:remote_account) }
  it { is_expected.to have_one(:account).through(:remote_account) }
  it { is_expected.to have_one(:connection).dependent(:destroy) }
  it { is_expected.to have_one(:rental).through(:connection) }

  it { is_expected.to validate_presence_of(:uid) }
  it { is_expected.to validate_uniqueness_of(:uid) }
  it { is_expected.to validate_presence_of(:remote_account) }

  describe '#connected?' do
    subject { remote_rental.connected? }
    context 'when rental present' do
      let(:remote_rental) { build(:remote_rental, rental: build(:rental)) }
      it { is_expected.to eq(true) }
    end

    context 'when rental nil' do
      let(:remote_rental) { build(:remote_rental, rental: nil) }
      it { is_expected.to eq(false) }
    end
  end
end
