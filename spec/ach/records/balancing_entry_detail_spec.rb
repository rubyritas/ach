require 'spec_helper'

describe ACH::Records::BalancingEntryDetail do
  include ACH::FieldIdentifiers

  describe '#record_type' do
    subject(:entry) do 
      described_class.new.tap do |entry|
        entry.transaction_code         = transaction_code
        entry.routing_number           = routing_number
        entry.account_number           = account_number
        entry.amount                   = amount
        entry.account_description      = account_description
        entry.discretionary_data       = discretionary_data
        entry.addenda_record_indicator = addenda_record_indicator
        entry.origin_routing_number    = origin_routing_number
        entry.trace_number             = trace_number
      end
    end

    let(:record_type) { '6' }
    let(:transaction_code) { '27' }
    let(:routing_number) { '156530466' }
    let(:account_number) { '888224419' }
    let(:amount) { 2207803 }
    let(:individual_id_number) { (' ' * 15) }
    let(:account_description) { 'OFFSET' }
    let(:discretionary_data) { '  ' }
    let(:addenda_record_indicator) { 0 }
    let(:origin_routing_number) { '15653046' }
    let(:trace_number) { 3 }

    let(:formatted_routing_number) { left_justify(routing_number, 9) }
    let(:formatted_account_number) { left_justify(account_number, 17) }
    let(:formatted_amount) { sprintf('%010d', amount) }
    let(:formatted_account_description) do
      left_justify(account_description, 22)
    end
    let(:formatted_addenda_record_indicator) do
      sprintf('%01d', addenda_record_indicator)
    end
    let(:formatted_origin_routing_number) do
      sprintf('%08d', origin_routing_number)
    end
    let(:formatted_trace_number) do
      sprintf('%07d', trace_number)
    end

    let(:expected_results) do
      [
        record_type,
        transaction_code,
        formatted_routing_number,
        formatted_account_number,
        formatted_amount,
        individual_id_number,
        formatted_account_description,
        discretionary_data,
        formatted_addenda_record_indicator,
        formatted_origin_routing_number,
        formatted_trace_number
      ].join('')
    end

    context 'record type code' do
      it "has a value of 6'" do
        expect(entry.record_type_to_ach).to eq('6')
      end
      it 'occupies column 0' do
        expect(entry.to_ach[0]).to eq(record_type)
      end
    end

    context 'transaction_code' do
      it 'has a numeric value' do
        expect(entry.transaction_code_to_ach).to eq(transaction_code)
      end
      it 'occupies columns 1 through 2' do
        expect(entry.to_ach[1..2]).to eq(transaction_code)
      end
    end

    context 'routing number' do
      it 'outputs a routing number' do
        expect(entry.routing_number_to_ach).to eq(routing_number)
      end
      it 'occupies columns 3 through 11' do
        expect(entry.to_ach[3..11]).to eq(routing_number)
      end
    end

    context 'account number' do
      it 'outputs an account number' do
        expect(entry.account_number_to_ach).to eq(formatted_account_number)
      end
      it 'occupies columns 12 through 28' do
        expect(entry.to_ach[12..28]).to eq(formatted_account_number)
      end
    end

    context 'amount' do
      it 'outputs an amount' do
        expect(entry.amount_to_ach).to eq(formatted_amount)
      end
      it 'occupies columns 29 through 38' do
        expect(entry.to_ach[29..38]).to eq(formatted_amount)
      end
    end

    context 'individual_id_number' do
      it 'outputs an individual_id_number' do
        expect(entry.individual_id_number_to_ach).to eq(individual_id_number)
      end
      it 'occupies columns 39 through 53' do
        expect(entry.to_ach[39..53]).to eq(individual_id_number)
      end
    end

    context 'account_description' do
      it 'outputs a bank book account description' do
        expect(entry.account_description_to_ach).to eq(formatted_account_description)
      end
      it 'occupies columns 54 through 75' do
        expect(entry.to_ach[54..75]).to eq(formatted_account_description)
      end
    end

    context 'discretionary_data' do
      it 'outputs two blank spaces' do
        expect(entry.discretionary_data_to_ach).to eq(discretionary_data)
      end
      it 'occupies columns 76 through 77' do
        expect(entry.to_ach[76..77]).to eq(discretionary_data)
      end
    end

    context 'addenda_record_indicator' do
      it 'outputs zero or one' do
        expect(entry.addenda_record_indicator_to_ach).to eq(formatted_addenda_record_indicator)
      end
      it 'occupies column 78' do
        expect(entry.to_ach[78]).to eq(formatted_addenda_record_indicator)
      end
    end

    context 'origin_routing number' do
      it 'outputs the origin routing number' do
        expect(entry.origin_routing_number_to_ach).to eq(formatted_origin_routing_number)
      end
      it 'occupies columns 79 through 8' do
        expect(entry.to_ach[79..86]).to eq(formatted_origin_routing_number)
      end
    end

    context 'trace_number' do
      it 'outputs a zero padded seven digit number' do
        expect(entry.trace_number_to_ach).to eq(formatted_trace_number)
      end
      it 'occupies columns 87 to 93' do
        expect(entry.to_ach[87..93]).to eq(formatted_trace_number)
      end
    end

    it 'outputs a long string' do
      expect(entry.to_ach).to eq(expected_results)
      expect(entry.to_ach.length).to eq(94)
    end
  end
end
