require 'rails_helper'

RSpec.describe RemoteAccount, type: :model do
  it { is_expected.to belong_to :account }
  it { is_expected.to have_many(:remote_rentals).dependent(:destroy) }

  it { is_expected.to validate_presence_of :uid }
  it { is_expected.to validate_uniqueness_of :uid }

  it { is_expected.to validate_presence_of :account }
end
