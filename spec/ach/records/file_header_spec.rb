require 'spec_helper'

describe ACH::Records::FileHeader do
  before(:each) do
    @header = ACH::Records::FileHeader.new
    @header.immediate_destination_name = 'destination'
    @header.immediate_destination = '123456789'
    @header.immediate_origin_name = 'origin'
    @header.immediate_origin = '123456789'
  end

  describe '#to_ach' do
    it 'has 94 characters' do
      expect(@header.to_ach.size).to eq(94)
    end
  end

  describe '#immediate_origin_to_ach' do
    it 'adds a leading space when only 9 digits' do
      expect(@header.immediate_origin_to_ach).to eq(' 123456789')
    end

    it 'does not add a leading space when 10 digits' do
      @header.immediate_origin = '1234567890'
      expect(@header.immediate_origin_to_ach).to eq('1234567890')
    end

    it 'allows a leading letter' do
      @header.immediate_origin = 'A123456789'
      expect(@header.immediate_origin_to_ach).to eq('A123456789')
    end

    it 'allows a leading number' do
      @header.immediate_origin = '1234567890'
      expect(@header.immediate_origin_to_ach).to eq('1234567890')
    end

    it 'allows a leading space' do
      @header.immediate_origin = ' 123456789'
      expect(@header.immediate_origin_to_ach).to eq(' 123456789')
    end

    it 'allows a trailing space' do
      @header.immediate_origin = '123456789 '
      expect(@header.immediate_origin_to_ach).to eq('123456789 ')
    end
  end

  describe '#immediate_destination_to_ach' do
    it 'adds a leading space when only 9 digits' do
      expect(@header.immediate_destination_to_ach).to eq(' 123456789')
    end

    it 'does not add a leading space when 10 digits' do
      @header.immediate_destination = '1234567890'
      expect(@header.immediate_destination_to_ach).to eq('1234567890')
    end
  end
end
