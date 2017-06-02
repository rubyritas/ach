require 'spec_helper'

module ACH
  module FieldTypes
    describe AccountNumber do
      describe '.default_length' do
        it 'is 17' do
          expect(AccountNumber.default_length).to eq(17)
        end
      end

      describe '#initialize' do
        it 'sets value, stripping spaces' do
          account = AccountNumber.new('0012 2356')
          expect(account.value).to eq('00122356')

          account = AccountNumber.new(321654987)
          expect(account.value).to eq('321654987')
        end
      end

      describe '#ach' do
        context 'length of value less than @length' do
          subject(:account_number) { AccountNumber.new(1235409) }

          it 'is a left-justified string of length characters' do
            expect(account_number.ach).to eq('1235409          ')
          end
        end

        context 'length of value greater than @length' do
          subject(:account_number) { AccountNumber.new(12345678901234567890) }

          it 'truncates value to length' do
            expect(account_number.ach).to eq('12345678901234567')
          end
        end
      end

      describe '#valid?' do
        it 'does not have validations (always true)' do
          expect(AccountNumber.new('test').valid?).to be(true)
        end
      end
    end
  end
end
