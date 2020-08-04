# encoding: utf-8
require 'spec_helper'

describe ACH::Batch do
  before(:each) do
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

  describe '#to_ach' do
    it 'should determine BatchHeader#service_class_code if not set' do
      debits = new_batch
      debits.entries << @debit << @debit
      expect(debits.header.service_class_code).to be_nil
      debits.to_ach
      expect(debits.header.service_class_code).to eq(225)

      credits = new_batch
      credits.entries << @credit << @credit
      expect(credits.header.service_class_code).to be_nil
      credits.to_ach
      expect(credits.header.service_class_code).to eq(220)

      both = new_batch
      both.entries << @credit << @debit
      expect(both.header.service_class_code).to be_nil
      both.to_ach
      expect(both.header.service_class_code).to eq(200)
    end

    it 'should not override BatchHeader#service_class_code if already set' do
      debits = new_batch
      debits.header.service_class_code = 200
      debits.entries << @debit << @debit
      debits.to_ach
      expect(debits.header.service_class_code).to eq(200)

      debits = new_batch
      debits.header.service_class_code = '220'
      debits.entries << @credit << @credit
      debits.to_ach
      expect(debits.header.service_class_code).to eq('220')
    end

    it 'should set BatchControl#service_class_code from BatchHeader if not set' do
      batch = new_batch
      batch.header.service_class_code = 200
      expect(batch.control.service_class_code).to be_nil
      batch.to_ach
      expect(batch.control.service_class_code).to eq(200)

      batch = new_batch
      batch.header.service_class_code = '225'
      expect(batch.control.service_class_code).to be_nil
      batch.to_ach
      expect(batch.control.service_class_code).to eq('225')

      debits = new_batch
      debits.entries << @debit << @debit
      expect(debits.header.service_class_code).to be_nil
      expect(debits.control.service_class_code).to be_nil
      debits.to_ach
      expect(debits.header.service_class_code).to eq(225)
    end

    it 'should set BatchControl#company_identification from BatchHeader' do
      batch = new_batch
      expect(batch.control.company_identification).to be_nil
      batch.to_ach
      expect(batch.control.company_identification).to eq("123456789")
    end

    it 'should set BatchControl#originating_dfi_identification from BatchHeader' do
      batch = new_batch
      expect(batch.control.originating_dfi_identification).to be_nil
      batch.to_ach
      expect(batch.control.originating_dfi_identification).to eq("00000000")
    end

    it 'should not override BatchHeader#service_class_code if already set' do
      # Granted that I can't imagine this every being used...
      batch = new_batch
      batch.header.service_class_code = 220
      batch.control.service_class_code = 200
      batch.to_ach
      expect(batch.control.service_class_code).to eq(200)
    end

    it 'should truncate fields that exceed the length in left_justify' do
      @credit.individual_name = "Employee Name That Is Much Too Long"
      expect(@credit.individual_name_to_ach).to eq("Employee Name That Is ")
    end

    it 'should remove new line characters' do
      @credit.individual_name = "Multiline\nName\r\n"
      expect(@credit.individual_name_to_ach).to eq("MultilineName         ")
    end

    it 'should strip non ascii characters' do
      @credit.individual_name = "Jacob Møller"
      expect(@credit.individual_name_to_ach).to eq("Jacob Mller           ")
    end
  end
end
