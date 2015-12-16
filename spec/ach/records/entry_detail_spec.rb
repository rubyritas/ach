require 'spec_helper'

module ACH
  module Records
    describe EntryDetail do
      describe '#record_type' do
        it "is a constant field with the value of '6'" do
          expect(subject.record_type_to_ach).to eq('6')
          expect(subject).not_to respond_to(:record_type=)
        end
      end

      describe '#transaction_code' do
        it_behaves_like 'a transaction code (String)'
      end

      describe '#routing_number' do
        it_behaves_like 'a routing number (String)'
      end

      describe '#account_number' do
        it_behaves_like 'an account number (String)'
      end

      describe '#amount' do
        let(:amount_length) { 10 }
        it_behaves_like 'an amount (Integer)'
      end
    end
  end
end
