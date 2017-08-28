require 'rails_helper'

RSpec.describe Rental do
  it { is_expected.to belong_to(:account) }
  it { is_expected.to have_one(:connection).dependent(:destroy) }
  it { is_expected.to have_one(:remote_rental).through(:connection) }
  it { is_expected.to have_many(:photos).dependent(:destroy) }
  it { is_expected.to have_many(:rates).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:synced_id) }
  it { is_expected.to validate_uniqueness_of(:synced_id) }

  describe '.connected' do
    subject { described_class.connected }
    let(:connection_1) { create(:connection) }
    let(:rental_1) { connection_1.rental }
    let(:connection_2) { create(:canceled_connection) }
    let(:rental_2) { connection_2.rental }
    let(:rental_3) { create(:rental, remote_rental: nil) }

    it { is_expected.to eq [rental_1] }
  end

  describe '.not_connected' do
    subject { described_class.not_connected }
    let(:connection_1) { create(:connection) }
    let(:rental_1) { connection_1.rental }
    let(:connection_2) { create(:canceled_connection) }
    let(:rental_2) { connection_2.rental }
    let(:rental_3) { create(:rental, remote_rental: nil) }

    it { is_expected.to eq [rental_2, rental_3] }
  end

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

  describe '#ordered_photos' do
    subject { rental.ordered_photos }
    let(:rental) { create(:rental) }
    let(:photo) { create(:photo, position: 2, rental: rental) }
    let(:photo2) { create(:photo, position: 1, rental: rental) }

    it { is_expected.to eq [photo2, photo] }
  end
end
