shared_examples 'an amount (Integer)' do
  it 'produces a 0-padded string of a set length' do
    {
      '123' => '123', 9876543210 => '9876543210', 124.12 => '124'
    }.each do |input, str|
      subject.amount = input
      expected = '0' * (amount_length - str.length) + str
      expect(subject.amount_to_ach).to eq(expected)
    end
  end

  it 'has no default' do
    expect(subject.routing_number).to be_nil
  end
end
