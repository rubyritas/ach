# frozen_string_literal: true

require 'spec_helper'
require 'ach/records/shared/batch_summaries'

describe ACH::Records::BatchHeader do
  before(:each) do
    @record = ACH::Records::BatchHeader.new
  end

  instance_eval(&SharedExamples.batch_summaries)

  describe '#standard_entry_class_code' do
    it 'defaults to PPD' do
      expect(@record.standard_entry_class_code_to_ach).to eq('PPD')
    end

    it 'capitalizes' do
      @record.standard_entry_class_code = 'ccd'
      expect(@record.standard_entry_class_code_to_ach).to eq('CCD')
    end

    it 'allows exactly three characters' do
      expect { @record.standard_entry_class_code = 'CCDA' }
        .to raise_error(RuntimeError)
      expect { @record.standard_entry_class_code = 'CC' }
        .to raise_error(RuntimeError)
      expect { @record.standard_entry_class_code = 'CCD' }.not_to raise_error
    end

    describe 'batch header - company identification' do
      it 'allows numeric values' do
        expect { @record.company_identification = '012345678' }
          .not_to raise_error
      end

      it 'allows alphanumeric values, with a leading letter' do
        expect { @record.company_identification = 'A12345678' }
          .not_to raise_error
      end

      it 'allows leading space padding' do
        expect { @record.company_identification = '   9876543' }
          .not_to raise_error
      end

      it 'errors on invalid length, 6 digits' do
        expect { @record.company_identification = '123456' }.to raise_error
      end

      it 'errors on invalid length, 11 digits' do
        expect { @record.company_identification = '11234567890' }.to raise_error
      end
    end
  end
end
