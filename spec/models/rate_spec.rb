require 'rails_helper'

RSpec.describe Rate do
  it { is_expected.to have_one(:account).through(:rental) }
  it { is_expected.to belong_to(:rental) }
end
