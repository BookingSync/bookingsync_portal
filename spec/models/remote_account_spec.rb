require 'rails_helper'

RSpec.describe RemoteAccount do
  it { is_expected.to belong_to :account }
  it { is_expected.to have_many(:remote_rentals).dependent(:destroy) }

  it { is_expected.to validate_presence_of :uid }
  it { is_expected.to validate_uniqueness_of :uid }

  it { is_expected.to validate_presence_of :account }

  describe "#name" do
    subject { described_class.first.name }
    let!(:remote_account) { create(:remote_account, uid: 11) }

    it { is_expected.to eq 11 }
  end
end
