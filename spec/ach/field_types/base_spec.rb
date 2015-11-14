require 'spec_helper'

module ACH
  module FieldTypes
    describe Base do
      subject(:field) { Base.new 'Value' }

      describe '#initialize' do
        it 'sets the value' do
          expect(Base.new('The Val').ach).to eq('The Val')
        end
      end

      describe '#ach' do
        it 'returns @value' do
          expect(field.ach).to eq('Value')
        end
      end

      describe '#valid?' do
        it 'is true' do
          expect(field.valid?).to be(true)
        end
      end

      describe '#invalid!' do
        it 'raises InvalidError' do
          expect { field.invalid! 'is not valid' }.to raise_error(
            ACH::InvalidError, 'ACH::FieldTypes::Base (Value) is not valid.'
          )
        end
      end

      describe '.default_length=' do
        it 'records the default length for this field type' do
          Base.default_length = 5
          expect(Base.default_length).to eq(5)
        end
      end

      describe '.parse' do
        it 'initializes a new instance with the provided value' do
          parsed = Base.parse('test')
          expect(parsed.class).to be(Base)
          expect(parsed.ach).to eq('test')
        end
      end
    end
  end
end
