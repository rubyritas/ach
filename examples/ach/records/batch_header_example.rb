require 'example_helper'

describe ACH::Records::BatchHeader do
  before(:each) do
    @record = ACH::Records::BatchHeader.new
  end
  
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
      lambda { @record.standard_entry_class_code = 'CCD' }.should_not raise_error(RuntimeError)
    end
    
    it 'should be limited to real codes'
  end
  
  describe '#service_class_code' do
    it 'should accept an Integer'
    it 'should accept a String'
    it 'must be a 200, 220, 225 or 280'
   
    describe '#service_class_code_to_ach' do
      it 'should use a given value'
      it 'should default to determining from entries'
    end
  end
end
