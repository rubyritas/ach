require 'spec_helper'

describe "Parse" do
  describe 'Returns and NOC' do
    before(:each) do
      @data = File.read('spec/ach/fixtures/return_noc.txt')
    end

    it 'should produce the same number of entries as the original ACH file' do
      entries = ACH::ACHFile.new(@data).batches.reduce([]) { |entries, batch| entries << batch.entries }

      expect(entries.flatten.size).to eq(3)
    end

    it 'should parse the fixed-length ACH file' do
      fixed_length_file = File.read('spec/ach/fixtures/return_fixedlength.txt')
      ach_file = ACH::ACHFile.new
      ach_file.parse_fixed(fixed_length_file)
      expect(ach_file.batches.count).to eq(3)
    end

    it "should parse return/notification of change file" do
      fake_current_datetime = Date.new(2012, 10, 15)
      expected_datetime = DateTime.new(2012, 10, 15, 19, 32)
      allow(Date).to receive(:today).and_return(fake_current_datetime)

      ach = ACH::ACHFile.new(@data)
      fh = ach.header
      expect(fh.immediate_destination).to eq("191001234")
      expect(fh.immediate_origin).to eq("992222226")
      expect(fh.transmission_datetime).to eq(Time.utc(2012, 10, 15, 15, 18))
      expect(fh.immediate_destination_name).to eq("Certification Bank-Sili")
      expect(fh.immediate_origin_name).to eq("CERTIFICATION BANK-SILI")

      expect(ach.batches.size).to eq(3)

      batch = ach.batches[0]
      expect(batch.entries.size).to eq(1)
      bh = batch.header
      expect(bh.company_name).to eq("COMPANY INC")
      expect(bh.company_identification).to eq("412345678")
      expect(bh.full_company_identification).to eq("1412345678")
      expect(bh.standard_entry_class_code).to eq('COR')
      expect(bh.company_entry_description).to eq("DESCRIPT")
      expect(bh.company_descriptive_date).to eq(expected_datetime)
      expect(bh.effective_entry_date).to eq(Date.parse('121015'))
      expect(bh.originating_dfi_identification).to eq("99222222")

      second_batch = ach.batches[1]
      bh = second_batch.header
      expect(bh.company_name).to eq("COMPANY INC")
      expect(bh.company_identification).to eq("412345678")
      expect(bh.full_company_identification).to eq("1412345678")
      expect(bh.standard_entry_class_code).to eq('PPD')
      expect(bh.company_entry_description).to eq("DESCRIPT")
      expect(bh.company_descriptive_date).to eq(Date.parse('121015'))
      expect(bh.effective_entry_date).to eq(Date.parse('121015'))
      expect(bh.originating_dfi_identification).to eq("99222222")

      third_batch = ach.batches[2]
      bh = third_batch.header
      expect(bh.company_name).to eq("COMPANY INC")
      expect(bh.company_identification).to eq("412345678")
      expect(bh.full_company_identification).to eq("1412345678")
      expect(bh.standard_entry_class_code).to eq('PPD')
      expect(bh.company_entry_description).to eq("DESCRIPT")
      expect(bh.company_descriptive_date).to eq('nodate')
      expect(bh.effective_entry_date).to eq(Date.parse('121015'))
      expect(bh.originating_dfi_identification).to eq("99222222")

      ed = batch.entries[0]
      expect(ed.transaction_code).to eq("21")
      expect(ed.routing_number).to eq("121140399")
      expect(ed.account_number).to eq("3300911569")
      expect(ed.amount).to eq(0) # In cents
      expect(ed.individual_id_number).to eq("A38LTNY2")
      expect(ed.individual_name).to eq("NAME ONE")

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

    it 'should raise an appropriate error if the type code was not recognized' do
      ach_file = ACH::ACHFile.new
      expect { ach_file.parse('INVALID DATA') }.to raise_error(ACH::UnrecognizedTypeCode)
    end
  end
end
