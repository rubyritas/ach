require 'spec_helper'

describe ACH::Records::Nines do
  before(:each) do
    @nines = ACH::Records::Nines.new
  end

  describe '#to_ach' do
    it 'should generate 94 copies of the digit "9"' do
      expect(@nines.to_ach).to eq('9' * 94)
    end
  end
end
