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
    it 'should accept an Integer' do
      @record.service_class_code = 200
      @record.service_class_code.should == 200
      @record.service_class_code_to_ach.should == '200'
    end
    
    it 'should accept a String' do
      @record.service_class_code = '220'
      @record.service_class_code.should == '220'
      @record.service_class_code_to_ach.should == '220'
    end
    
    it 'must be a 200, 220, 225 or 280' do
      lambda { @record.service_class_code = '201' }.should raise_error(RuntimeError)
      lambda { @record.service_class_code = 201 }.should raise_error(RuntimeError)
      lambda { @record.service_class_code = '2020' }.should raise_error(RuntimeError)
      lambda { @record.service_class_code = '20' }.should raise_error(RuntimeError)
    end
   
    describe '#service_class_code_to_ach' do
      it 'should use a given value' do
        @record.service_class_code = '220'
        @record.service_class_code_to_ach.should == '220'
        @record.service_class_code = '225'
        @record.service_class_code_to_ach.should == '225'
      end
      
      it 'should default to 200 when entries unavailable' do
        @record.service_class_code_to_ach.should == '200'
      end
      
      it 'should default to determining from entries available'
    end
  end
end
