require 'spec_helper'
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
    
    it 'should be exactly three characters' do
      lambda { @record.standard_entry_class_code = 'CCDA' }.should raise_error(RuntimeError)
      lambda { @record.standard_entry_class_code = 'CC' }.should raise_error(RuntimeError)
      lambda { @record.standard_entry_class_code = 'CCD' }.should_not raise_error
    end
    
    it 'should be limited to real codes'
  end

  describe '#settlement_date' do
    it 'should be exactly three digits' do
      lambda { @record.settlement_date = '0' }.should raise_error(RuntimeError)
      lambda { @record.settlement_date = '0000' }.should raise_error(RuntimeError)
      lambda { @record.settlement_date = '000' }.should_not raise_error
    end

    it 'should contain only digits' do
      lambda { @record.settlement_date = '0A0' }.should raise_error(RuntimeError)
    end

    it 'should contain only three spaces' do
      lambda { @record.settlement_date = '   ' }.should_not raise_error
      lambda { @record.settlement_date = '  ' }.should raise_error(RuntimeError)
      lambda { @record.settlement_date = '    ' }.should raise_error(RuntimeError)
    end
  end
end
