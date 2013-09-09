require 'example_helper'
require 'ach/records/shared/batch_summaries'

describe ACH::Records::BatchHeader do
  before(:each) do
    @record = ACH::Records::BatchHeader.new
  end

  self.instance_eval(&SharedExamples.batch_summaries)

  describe '#standard_entry_class_code' do
    it 'should default to PPD' do
      @record.standard_entry_class_code_to_ach.should == 'PPD'
    end

    it 'should be capitalized' do
      @record.standard_entry_class_code = 'ccd'
      @record.standard_entry_class_code_to_ach.should == 'CCD'
    end

    it 'should allow for alphanumeric company identification codes ' do
      lambda { @record.company_identification_code_designator = 'A' }.should_not raise_error
    end

    it 'should be exactly three characters' do
      lambda { @record.standard_entry_class_code = 'CCDA' }.should raise_error(RuntimeError)
      lambda { @record.standard_entry_class_code = 'CC' }.should raise_error(RuntimeError)
      lambda { @record.standard_entry_class_code = 'CCD' }.should_not raise_error(RuntimeError)
    end

    it 'should be limited to real codes'
  end
end
