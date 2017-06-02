require 'spec_helper'

module ACH
  module FieldTypes
    describe RoutingNumber do
      describe '.default_length' do
        it 'is 9' do
          expect(RoutingNumber.default_length).to eq(9)
        end
      end

      describe '#initialize' do
        context '9-digit value with valid check digit' do
          it 'sets identification from first 8 digits, and check digit' do
            expect_any_instance_of(RoutingNumber).to_not receive(:invalid!)
            routing = RoutingNumber.new('076401251')
            expect(routing.identification).to eq('07640125')
            expect(routing.check_digit).to eq('1')
          end
        end

        context '9-digit value with invalid check digit' do
          it 'sets identification from first 8 digits, and check digit, and calls invalid!' do
            expect_any_instance_of(RoutingNumber).to receive(:invalid!)
            routing = RoutingNumber.new('076401253')
            expect(routing.identification).to eq('07640125')
            expect(routing.check_digit).to eq('3')
          end
        end

        context '8-digit value' do
          it 'sets identification and calculates check digit' do
            expect_any_instance_of(RoutingNumber).to_not receive(:invalid!)
            routing = RoutingNumber.new('07640125')
            expect(routing.identification).to eq('07640125')
            expect(routing.check_digit).to eq('1')
          end
        end

        context 'value is less than 8 digits' do
          it 'calls invalid!' do
            expect_any_instance_of(RoutingNumber).to receive(:invalid!).
              with('must be 8 digits long (or 9 digits if including the check digit)').once
            routing = RoutingNumber.new('0764012')
            expect(routing.identification).to eq('0764012')
            expect(routing.check_digit).to be_empty
          end
        end

        context 'value is more than 9 digits' do
          it 'calls invalid!' do
            expect_any_instance_of(RoutingNumber).to receive(:invalid!).
              with('must be 8 digits long (or 9 digits if including the check digit)').once
            routing = RoutingNumber.new('0764012511')
            expect(routing.identification).to eq('0764012511')
            expect(routing.check_digit).to be_empty
          end
        end

        context 'value has non-digit character(s)' do
          it 'calls invalid!' do
            expect_any_instance_of(RoutingNumber).to receive(:invalid!).
              with('must be 8 digits long (or 9 digits if including the check digit)').once
            routing = RoutingNumber.new('0764012A')
            expect(routing.identification).to eq('0764012A')
            expect(routing.check_digit).to be_empty
          end
        end
      end

      describe '#calculate_check_digit' do
        context 'valid identification' do
          it 'returns the calculated check digit' do
            expect(RoutingNumber.new('076401251').calculate_check_digit).
              to eq(1)
            expect(RoutingNumber.new('07640125').calculate_check_digit).
              to eq(1)
            expect(RoutingNumber.new('123454326').calculate_check_digit).
              to eq(6)
            expect(RoutingNumber.new('12345432').calculate_check_digit).
              to eq(6)
          end
        end

        context 'invalid identification' do
          it 'returns nil' do
            %w{0764012A 0764012 0764012511 ABCDEFGHI}.each do |identification|
              allow_any_instance_of(RoutingNumber).to receive(:invalid!)
              expect(RoutingNumber.new(identification).calculate_check_digit).
                to be(nil)
            end
          end
        end
      end

      describe '#ach' do
        it 'is the identification string and check digit' do
          expect(RoutingNumber.new('076401251').ach).to eq('076401251')
          expect(RoutingNumber.new('07640125').ach).to eq('076401251')
        end
      end

      describe '#valid?' do
        subject(:routing_number) { RoutingNumber.new('076401251') }

        context '#identification is not 8 digits' do
          it 'is not valid' do
            expect(routing_number).to receive(:invalid!).exactly(4).times.
              with('must be 8 digits long (or 9 digits if including the check digit)')
            %w{0764012A 0764012 0764012511 ABCDEFGHI}.each do |identification|
              routing_number.
                instance_variable_set(:@identification, identification)
              expect(routing_number.valid?).to be(false)
            end
          end
        end

        context 'invalid check digit' do
          it 'is not valid' do
            expect(routing_number).to receive(:invalid!).
              with('check digit (3) does not match expected value (1)')
            routing_number.instance_variable_set(:@check_digit, 3)
            expect(routing_number.valid?).to be(false)
          end
        end

        context 'identification is 8 digits and check digit is valid' do
          it 'is valid' do
            expect(routing_number).to_not receive(:invalid!)
            expect(routing_number.valid?).to be(true)
          end
        end
      end
    end
  end
end
