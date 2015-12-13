shared_examples 'a transaction code (String)' do
  it 'is a string with two digits' do
    ['22', '23', '29', '32', '88'].each do |val|
      subject.transaction_code = val
      expect(subject.transaction_code).to eq(val)
      expect(subject.transaction_code_to_ach).to eq(val)
    end

    ['', '2', '222', 'ab', '2a'].each do |val|
      expect{ subject.transaction_code = val }.to raise_error(ACH::InvalidError)
    end
  end

  it 'has no default' do
    expect(subject.transaction_code).to be_nil
  end
end
