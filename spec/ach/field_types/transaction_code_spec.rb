require 'spec_helper'

module ACH
  module FieldTypes
    describe TransactionCode do
      describe '#initialize' do
        it 'sets value as a String' do
          expect(TransactionCode.new(22).value).to eq('22')
          expect(TransactionCode.new('27').value).to eq('27')
        end
      end

      describe '#ach' do
        it 'is the value' do
          expect(TransactionCode.new(22).ach).to eq('22')
          expect(TransactionCode.new('27').ach).to eq('27')
        end
      end

      describe '#description' do
        context 'value in CODES hash' do
          it 'is the description value from CODES' do
            expect(TransactionCode.new(27).description).to eq('Demand Debit')
            expect(TransactionCode.new('37').description).to eq('Savings Debit')
          end
        end

        context 'value not in CODES hash' do
          it 'is a string containing the value' do
            expect(TransactionCode.new(99).description).
              to eq('Transaction Code 99')
          end
        end
      end

      describe '#valid?' do
        context 'value is exactly 2 digits' do
          it 'is valid' do
            ['21', 22, '23', 27, '32', '33', 37, 52, '53'].each do |value|
              expect(TransactionCode.new(value).valid?).to be(true)
            end
          end
        end

        context 'value consists of other than two digits' do
          it 'is invalid' do
            invalid = ['2', 211, 1, 'AB', '23B', 'B7']

            transaction_code = TransactionCode.new('22')

            expect(transaction_code).to receive(:invalid!).
              exactly(invalid.length).times.
              with('must consist of exactly two digits')

            invalid.each do |value|
              transaction_code.instance_variable_set(:@value, value)
              expect(transaction_code.valid?).to be(false)
            end
          end
        end
      end
    end
  end
end
