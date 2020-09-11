require 'rails_helper'

RSpec.describe Connection do
  it { is_expected.to belong_to :remote_rental }
  it { is_expected.to belong_to :rental }

  it { is_expected.to validate_presence_of :remote_rental }
  it { is_expected.to validate_presence_of :rental }

  context 'when remote rental and rental belong to different accounts' do
    let(:remote_rental) { build(:remote_rental) }
    let(:rental) { build(:rental) }

    subject { build(:connection, remote_rental: remote_rental, rental: rental).tap(&:valid?) }

    it { is_expected.to be_invalid }
    it 'has proper error message' do
      expect(subject.errors[:base]).to include('Different ownership of rental and remote_rental')
    end
  end

  context 'message_bus' do
    let(:account) { create(:account, id: 123) }
    let!(:rental) { create(:rental, account: account, id: 543) }
    let!(:remote_rental) { create(:remote_rental, account: account) }
    let(:connection) { build(:connection, rental: rental, remote_rental: remote_rental) }

    subject(:save) { connection.save }

    context 'on_save' do
      it 'publishes notification via message_bus' do
        expect(MessageBus).to receive(:publish).with("/account-123",
          { refresh_from: '/admin/rentals/543.js' })
        save
      end
    end
  end
end
