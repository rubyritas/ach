# frozen_string_literal: true

require 'spec_helper'
require 'ach/records/shared/batch_summaries'

describe ACH::Records::BatchControl do
  before(:each) do
    @record = ACH::Records::BatchControl.new
    @record.entry_count = 1
    @record.entry_hash = 2
    @record.debit_total = 3
    @record.credit_total = 4
    @record.company_identification = '123456789'
    @record.message_authentication_code = '22345678'
    @record.originating_dfi_identification = '32345678'
    @record.batch_number = 5
  end

  instance_eval(&SharedExamples.batch_summaries)

  describe '#to_ach' do
    it 'generates a record string' do
      exp = [
        '8',
        '200',
        '000001',
        '0000000002',
        '000000000003',
        '000000000004',
        '1123456789',
        '22345678           ',
        '      ',
        '32345678',
        '0000005'
      ]
      expect(@record.to_ach).to eq(exp.join(''))
    end
  end

  describe 'batch control - company identification' do
    it 'allows numeric values' do
      expect { @record.company_identification = '012345678' }.not_to raise_error
    end

    it 'allows alphanumeric values, with a leading letter' do
      expect { @record.company_identification = 'A12345678' }.not_to raise_error
    end

    it 'allows leading whitespace padding' do
      expect { @record.company_identification = '   1234567' }
        .not_to raise_error
    end

    it 'does not allow invalid length, 6 digits' do
      expect { @record.company_identification = '123456' }.to raise_error
    end

    it 'does not allow invalid length, 11 digits' do
      expect { @record.company_identification = '01234567890' }.to raise_error
    end
  end
end
