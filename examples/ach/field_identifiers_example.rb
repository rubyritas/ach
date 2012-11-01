require 'example_helper'

describe ACH::FieldIdentifiers do
  describe 'setter' do
    before(:each) do
      @klass = Class.new(ACH::Records::Record)
      @klass.instance_variable_set(:@fields, [])
    end
    
    it 'should validate against a Regexp' do
      @klass.field(:sample, String, nil, nil, /\A\w{5}\Z/)
      record = @klass.new
      lambda { record.sample = 'abcd' }.should raise_error(RuntimeError)
      record.sample.should be_nil
      lambda { record.sample = 'abcdef' }.should raise_error(RuntimeError)
      record.sample.should be_nil
      lambda { record.sample = 'abcde' }.should_not raise_error
      record.sample.should == 'abcde'
    end
      
    it 'should validate against a Proc' do
      block = Proc.new do |val|
        [1, 2, 500].include?(val)
      end
      
      @klass.field(:sample, String, nil, nil, block)
      record = @klass.new
      lambda { record.sample = 5 }.should raise_error(RuntimeError)
      record.sample.should be_nil
      lambda { record.sample = 501 }.should raise_error(RuntimeError)
      record.sample.should be_nil
      lambda { record.sample = 1 }.should_not raise_error
      record.sample.should == 1
      lambda { record.sample = 500 }.should_not raise_error
      record.sample.should == 500
    end
    
    it 'should set instance variable' do
      @klass.field(:sample, String)
      record = @klass.new
      record.sample = 'abcde'
      record.instance_variable_get(:@sample).should == 'abcde'
    end
  end
end
