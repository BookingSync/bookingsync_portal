require 'rails_helper'

RSpec.describe Photo do
  it { is_expected.to have_one(:account).through(:rental) }
  it { is_expected.to belong_to(:rental) }

  describe '#ordered' do
    subject { described_class.ordered }
    let(:photo) { Photo.find_by(position: 2) }
    let(:photo2) { Photo.find_by(position: 1) }

    before do
      create(:photo, position: 2)
      create(:photo, position: 1)
    end

    it { is_expected.to eq [photo2, photo] }
  end
end
