shared_examples 'a routing number' do
  it 'is a string with nine digits' do
    ['123456789', '012345678'].each do |val|
      subject.routing_number = val
      subject.routing_number.should == val
      subject.routing_number_to_ach.should == val
    end

    ['12345678', '1234567890', '12345678A', 123456789].each do |val|
      expect{ subject.routing_number = val }.to raise_error(RuntimeError)
    end
  end

  it 'has no default' do
    subject.routing_number.should be_nil
  end
end
