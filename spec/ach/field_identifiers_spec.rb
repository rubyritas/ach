require 'spec_helper'

describe ACH::FieldIdentifiers do
  describe 'setter' do

    before(:each) do
      @klass = Class.new(ACH::Records::Record)
      @klass.instance_variable_set(:@fields, [])
    end
    
    it 'should validate against a Regexp' do
      @klass.field(:sample, String, nil, nil, /\A\w{5}\Z/)
      record = @klass.new
      expect { record.sample = 'abcd' }.to raise_error(RuntimeError)
      expect(record.sample).to be_nil
      expect { record.sample = 'abcdef' }.to raise_error(RuntimeError)
      expect(record.sample).to be_nil
      expect { record.sample = 'abcde' }.not_to raise_error
      expect(record.sample).to eq('abcde')
    end
      
    it 'should validate against a Proc' do
      block = Proc.new do |val|
        [1, 2, 500].include?(val)
      end
      
      @klass.field(:sample, String, nil, nil, block)
      record = @klass.new
      expect { record.sample = 5 }.to raise_error(RuntimeError)
      expect(record.sample).to be_nil
      expect { record.sample = 501 }.to raise_error(RuntimeError)
      expect(record.sample).to be_nil
      expect { record.sample = 1 }.not_to raise_error
      expect(record.sample).to eq(1)
      expect { record.sample = 500 }.not_to raise_error
      expect(record.sample).to eq(500)
    end
    
    it 'should set instance variable' do
      @klass.field(:sample, String)
      record = @klass.new
      record.sample = 'abcde'
      expect(record.instance_variable_get(:@sample)).to eq('abcde')
    end

  end
end
