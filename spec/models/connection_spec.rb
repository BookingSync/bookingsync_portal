require 'rails_helper'

RSpec.describe Connection, type: :model do
  it { is_expected.to belong_to :remote_rental }
  it { is_expected.to belong_to :rental }

  it { is_expected.to validate_presence_of :remote_rental }
  it { is_expected.to validate_presence_of :rental }

  context 'when remote rental and rental belong to different accounts' do
    let(:remote_rental) { build(:remote_rental) }
    let(:rental) { build(:rental) }
    subject do
      build(:connection, remote_rental: remote_rental, rental: rental)
    end

    it { is_expected.to be_invalid }

    it 'has proper error message' do
      subject.valid?
      expect(subject.errors[:base]).to include(
        'Different ownership of rental and remote_rental')
    end
  end
end
