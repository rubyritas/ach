require 'spec_helper'

module ACH
  module Records
    describe EntryDetail do
      describe '#record_type' do
        it "is a constant field with the value of '6'" do
          subject.record_type_to_ach.should == '6'
          subject.should_not respond_to(:record_type=)
        end
      end

      describe '#transaction_code' do
        it_behaves_like 'a transaction code'
      end

      describe '#routing_number' do
        it_behaves_like 'a routing number'
      end
    end
  end
end
