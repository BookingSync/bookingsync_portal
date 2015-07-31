require 'rails_helper'

RSpec.describe Account do
  describe 'included_modules' do
    subject { described_class.included_modules }

    it { is_expected.to include BookingSync::Engine::Model }
  end

  it { is_expected.to have_many(:remote_accounts).dependent(:destroy) }
  it { is_expected.to have_many(:remote_rentals).through(:remote_accounts) }
  it { is_expected.to have_many(:rentals).dependent(:destroy) }
  it { is_expected.to have_many(:connections).through(:rentals) }

  describe "#api" do
    subject { described_class.first.api }
    let!(:account) { create(:account) }

    it { is_expected.to be_instance_of BookingSync::Engine::APIClient }
    it { expect(subject.logger).to be_instance_of ActiveSupport::Logger }
  end

  describe "#self.api" do
    subject { described_class.api }
    let(:token) { OpenStruct.new(token: "token") }

    before { expect(BookingSync::Engine).to receive(:application_token).and_return(token) }

    it { is_expected.to be_instance_of BookingSync::API::Client }
    it { expect(subject.logger).to be_instance_of ActiveSupport::Logger }
  end
end
