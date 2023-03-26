require 'spec_helper'

describe ACH::StringFormattingHelper do
  describe '.self.stringify_with_same_day' do
    subject do
      ACH::StringFormattingHelper.stringify_with_same_day(value)
    end

    context 'Date' do
      let(:value) { Date.new(2022, 10, 15) }
      it { is_expected.to eq('221015') }
    end

    context 'Time' do
      let(:value) { Time.new(2022, 10, 15, 1) }
      it { is_expected.to eq('221015') }
    end

    context 'same day value' do
      let(:value) { 'SD0515' }
      it { is_expected.to eq('SD0515') }
    end

    context 'less than 6 characters' do
      let(:value) { 'short' }
      it { is_expected.to eq(' short') }
    end

    context 'more than 6 characters' do
      let(:value) { 'LONGSTRING' }
      it { is_expected.to eq('LONGST') }
    end
  end
end
