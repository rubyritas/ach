shared_examples 'a transaction code' do
  it 'is a string with two digits' do
    ['22', '23', '29', '32', '88'].each do |val|
      subject.transaction_code = val
      subject.transaction_code.should == val
      subject.transaction_code_to_ach.should == val
    end

    ['', '2', '222', 'ab', '2a'].each do |val|
      expect{ subject.transaction_code = val }.to raise_error(RuntimeError)
    end
  end

  it 'has no default' do
    subject.transaction_code.should be_nil
  end
end
