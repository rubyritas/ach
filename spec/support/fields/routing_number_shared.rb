shared_examples 'a routing number' do
  it 'is a RoutingNumber' do
    subject.routing_number = '076401251'
    expect(subject.routing_number).to be_a(ACH::FieldTypes::RoutingNumber)
    expect(subject.routing_number.identification).to eq('07640125')
    expect(subject.routing_number.check_digit).to eq('1')
    expect(subject.routing_number_to_ach).to eq('076401251')

    subject.routing_number = ACH::FieldTypes::RoutingNumber.new('07640125')
    expect(subject.routing_number.identification).to eq('07640125')
    expect(subject.routing_number.check_digit).to eq('1')
    expect(subject.routing_number_to_ach).to eq('076401251')
  end

  it 'is 9 digits (or 8 plus calculated check digit)' do
    ['1234567890', '12345678A', 123456789].each do |value|
      expect{ subject.routing_number = value }.
        to raise_error(ACH::InvalidError)
    end
  end

  it 'has no default' do
    expect(subject.routing_number).to be(nil)
  end
end

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
