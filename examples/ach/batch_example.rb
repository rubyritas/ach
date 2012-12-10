require 'example_helper'

describe ACH::Batch do
  before(:each) do
    @batch = ACH::Batch.new

    @credit = ACH::EntryDetail.new
    @credit.transaction_code = ACH::CHECKING_CREDIT
    @credit.routing_number = "000000000"
    @credit.account_number = "00000000000"
    @credit.amount = 100 # In cents
    @credit.individual_id_number = "Employee Name"
    @credit.individual_name = "Employee Name"
    @credit.originating_dfi_identification = '00000000'

    @debit = @credit.dup
    @debit.transaction_code = ACH::CHECKING_DEBIT
  end

  def new_batch
    batch = ACH::Batch.new
    bh = batch.header
    bh.company_name = "Company Name"
    bh.company_identification = "123456789"
    bh.standard_entry_class_code = 'PPD'
    bh.company_entry_description = "DESCRIPTION"
    bh.company_descriptive_date = Date.today
    bh.effective_entry_date = (Date.today + 1)
    bh.originating_dfi_identification = "00000000"
    return batch
  end

  describe '#to_s' do
    it 'should determine BatchHeader#service_class_code if not set' do
      debits = new_batch
      debits.entries << @debit << @debit
      debits.header.service_class_code.should be_nil
      debits.to_ach
      debits.header.service_class_code.should == 225

      credits = new_batch
      credits.entries << @credit << @credit
      credits.header.service_class_code.should be_nil
      credits.to_ach
      credits.header.service_class_code.should == 220

      both = new_batch
      both.entries << @credit << @debit
      both.header.service_class_code.should be_nil
      both.to_ach
      both.header.service_class_code.should == 200
    end

    it 'should not override BatchHeader#service_class_code if already set' do
      debits = new_batch
      debits.header.service_class_code = 200
      debits.entries << @debit << @debit
      debits.to_ach
      debits.header.service_class_code.should == 200

      debits = new_batch
      debits.header.service_class_code = '220'
      debits.entries << @credit << @credit
      debits.to_ach
      debits.header.service_class_code.should == '220'
    end

    it 'should set BatchControl#service_class_code from BatchHeader if not set' do
      batch = new_batch
      batch.header.service_class_code = 200
      batch.control.service_class_code.should be_nil
      batch.to_ach
      batch.control.service_class_code.should == 200

      batch = new_batch
      batch.header.service_class_code = '225'
      batch.control.service_class_code.should be_nil
      batch.to_ach
      batch.control.service_class_code.should == '225'

      debits = new_batch
      debits.entries << @debit << @debit
      debits.header.service_class_code.should be_nil
      debits.control.service_class_code.should be_nil
      debits.to_ach
      debits.header.service_class_code.should == 225
    end

    it 'should not override BatchHeader#service_class_code if already set' do
      # Granted that I can't imagine this every being used...
      batch = new_batch
      batch.header.service_class_code = 220
      batch.control.service_class_code = 200
      batch.to_ach
      batch.control.service_class_code.should == 200
    end
  end
end
