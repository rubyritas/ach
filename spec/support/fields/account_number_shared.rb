shared_examples 'an account number (String)' do
  it 'is a left justified string with 17 characters' do
    {
      '1234567890' => '1234567890       ',
      '1234567' => '1234567          ',
      '1234567890123456789' => '12345678901234567'
    }.each do |value, ach|
      subject.account_number = value
      expect(subject.account_number).to eq(value)
      expect(subject.account_number_to_ach).to eq(ach)
      expect(subject.account_number_to_ach.length).to eq(17)
    end
  end

  it 'has no default' do
    expect(subject.account_number).to be_nil
  end
end
