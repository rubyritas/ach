# Include with:
#
#     self.instance_eval(&shared_examples_for_batch_summaries)

module SharedExamples
  def self.batch_summaries
    Proc.new do
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
  end
end
