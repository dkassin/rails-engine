require 'rails_helper'

RSpec.describe Merchant type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many(:items) }
  end

  it '#all_merchant_ids' do
    expect(Merchant.all_merchant_ids).to eq([2,3,3])
  end
end
