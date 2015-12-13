shared_examples 'a routing number (String)' do
  it 'is a string with nine digits' do
    ['123456789', '012345678'].each do |val|
      subject.routing_number = val
      expect(subject.routing_number).to eq(val)
      expect(subject.routing_number_to_ach).to eq(val)
    end

    ['12345678', '1234567890', '12345678A', 123456789].each do |val|
      expect{ subject.routing_number = val }.to raise_error(ACH::InvalidError)
    end
  end

  it 'has no default' do
    expect(subject.routing_number).to be_nil
  end
end
