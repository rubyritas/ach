require 'spec_helper'

describe ACH::Records::CtxEntryDetail do
  before(:each) do
    @entry = ACH::CtxEntryDetail.new
    @entry.transaction_code = ACH::CHECKING_DEBIT
    @entry.routing_number = '023456789'
    @entry.account_number = '123456789'
    @entry.amount = 10000
    @entry.individual_name = "Bob Roberts"
    @entry.originating_dfi_identification = '02345678'
    @entry.individual_id_number = '1'
    @entry.trace_number = 1
  end

  describe '#addenda_records?' do
    it 'should do report if it contains addena records' do
      @entry.addenda_records?.should == false

      @entry.addenda << ACH::Addendum.new
      @entry.addenda_records?.should == true
    end

    it 'should print addenda records as part of to_ach' do
      addendum_1 = ACH::Addendum.new
      addendum_1.payment_data = ""
      addendum_1.sequence_number = "1"
      @entry.addenda << addendum_1
      @entry.addenda.size.should == 1

      addendum_2 = ACH::Addendum.new
      addendum_2.payment_data = ""
      addendum_2.sequence_number = "2"
      @entry.addenda << addendum_2
      @entry.addenda.size.should == 2

      # 705 is the beginning of an addendum record
      ach_string = @entry.to_ach
      ach_string.scan("705").count.should == 2
    end

    it 'should print fields different from a CCD/PPD record' do
      ach_string = @entry.to_ach
      ach_string.slice(39, 15).should == "1              "
      ach_string.slice(58, 16).should == "#{@entry.individual_name.upcase}     "
    end

    it 'should set addenda record indicators, count, and trace numbers' do
      #Set a trace number we expect to find in the addendum record
      expected_trace_number = "474"
      @entry.trace_number = expected_trace_number

      addendum_1 = ACH::Addendum.new
      addendum_1.payment_data = ""
      addendum_1.sequence_number = "1"
      @entry.addenda << addendum_1


      ach_string = @entry.to_ach
      # Test addenda record indicator
      ach_string.slice(78, 1).should == "1"
      # Test number of addenda records
      ach_string.slice(54, 4).should == "0001"
      # Test for trace number in each addendum record
      ach_string.scan(expected_trace_number).count.should == 2
    end
  end

  describe '#records_count' do
    it 'is 1 plus count of addenda' do
      @entry.records_count.should == 1

      @entry.addenda << ACH::Addendum.new
      @entry.records_count.should == 2

      @entry.addenda << ACH::Addendum.new
      @entry.addenda << addendum_2

      @entry.records_count.should == 3
    end
  end
end
