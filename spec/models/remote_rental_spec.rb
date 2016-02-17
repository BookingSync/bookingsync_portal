require 'rails_helper'

RSpec.describe RemoteRental do
  it { is_expected.to serialize(:remote_data).as(BookingsyncPortal::MashSerializer) }

  it { is_expected.to belong_to(:remote_account) }
  it { is_expected.to have_one(:account).through(:remote_account) }
  it { is_expected.to have_one(:connection).dependent(:destroy) }
  it { is_expected.to have_one(:rental).through(:connection) }

  it { is_expected.to validate_uniqueness_of(:uid).allow_nil }
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

  describe '#synchronized?' do
    subject { remote_rental.synchronized? }
    context 'when synchronized_at is present' do
      let(:remote_rental) { build(:remote_rental, synchronized_at: 1.day.ago) }
      it { is_expected.to eq(true) }
    end

    context 'when synchronized_at is blank' do
      let(:remote_rental) { build(:remote_rental, synchronized_at: nil) }
      it { is_expected.to eq(false) }
    end
  end

  describe "#display_name" do
    subject { remote_rental.display_name }
    let(:remote_rental) { create(:remote_rental, uid: 11) }

    it { is_expected.to eq 11 }
  end
end
