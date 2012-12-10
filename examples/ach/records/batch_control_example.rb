require 'example_helper'
require 'ach/records/shared/batch_summaries'

describe ACH::Records::BatchControl do
  before(:each) do
    @record = ACH::Records::BatchControl.new
    @record.entry_count = 1
    @record.entry_hash = 2
    @record.debit_total = 3
    @record.credit_total = 4
    @record.company_identification = '1234567890'
    @record.message_authentication_code = '22345678'
    @record.originating_dfi_identification = '32345678'
    @record.batch_number = 5
  end

  self.instance_eval(&SharedExamples.batch_summaries)

  describe '#to_ach' do
    it 'should generate record string' do
      exp = [
        '8',
        '200',
        '000001',
        '0000000002',
        '000000000003',
        '000000000004',
        '1234567890',
        '22345678           ',
        '      ',
        '32345678',
        '0000005'
      ]
      @record.to_ach.should == exp.join('')
    end
  end
end
