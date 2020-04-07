# frozen_string_literal: true

require 'spec_helper'

describe 'Parse' do
  describe 'Returns and NOC' do
    before(:each) do
      @data = File.read('spec/ach/fixtures/return_noc.txt')
    end

    it 'produces the same number of entries as the original ACH file' do
      all_entries =
        ACH::ACHFile.new(@data).batches.reduce([]) do |entries, batch|
          entries << batch.entries
        end

      expect(all_entries.flatten.size).to eq(3)
    end

    it 'parses a return/notification of change file' do
      ach = ACH::ACHFile.new(@data)
      fh = ach.header
      expect(fh.immediate_destination).to eq('191001234')
      expect(fh.immediate_origin).to eq('992222226')
      expect(fh.transmission_datetime).to eq(Time.utc(2012, 10, 15, 15, 18))
      expect(fh.immediate_destination_name).to eq('Certification Bank-Sili')
      expect(fh.immediate_origin_name).to eq('CERTIFICATION BANK-SILI')

      expect(ach.batches.size).to eq(3)

      batch = ach.batches[0]
      expect(batch.entries.size).to eq(1)
      bh = batch.header
      expect(bh.company_name).to eq('COMPANY INC')
      expect(bh.company_identification).to eq('412345678')
      expect(bh.standard_entry_class_code).to eq('COR')
      expect(bh.company_entry_description).to eq('DESCRIPT')
      expect(bh.company_descriptive_date).to eq(Date.parse('121015'))
      expect(bh.effective_entry_date).to eq(Date.parse('121015'))
      expect(bh.originating_dfi_identification).to eq('99222222')

      ed = batch.entries[0]
      expect(ed.transaction_code).to eq('21')
      expect(ed.routing_number).to eq('121140399')
      expect(ed.account_number).to eq('3300911569')
      expect(ed.amount).to eq(0)
      expect(ed.individual_id_number).to eq('A38LTNY2')
      expect(ed.individual_name).to eq('NAME ONE')

      expect(ed.addenda.size).to eq(1)
      ad = ed.addenda[0]
      expect(ad.type_code).to eq('98')
      expect(ad.reason_code).to eq('C05')
      expect(ad.original_entry_trace_number).to eq('992222220280489')
      expect(ad.corrected_data).to eq('32')
      expect(ad.sequence_number).to eq(4039)

      batch = ach.batches[1]
      expect(batch.entries.size).to eq(1)
      bh = batch.header
      expect(bh.standard_entry_class_code).to eq('PPD')
      ed = batch.entries[0]
      expect(ed.amount).to eq(2536)

      expect(ed.addenda.size).to eq(1)
      ad = ed.addenda[0]
      expect(ad.type_code).to eq('99')
      expect(ad.reason_code).to eq('R07')
      expect(ad.original_entry_trace_number).to eq('992222220280393')
      expect(ad.addenda_information).to eq('INVALID')
    end
  end
end
