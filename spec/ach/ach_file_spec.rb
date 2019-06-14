require 'spec_helper'

describe ACH::ACHFile do

  subject :ach_file do
    # Create ACH file
    ach = ACH::ACHFile.new

    # File Header
    fh = ach.header
    fh.immediate_destination = '000000000'
    fh.immediate_destination_name = 'BANK NAME'
    fh.immediate_origin = '000000000'
    fh.immediate_origin_name = 'BANK NAME'

    ach
  end

  def add_batch_with_addenda ach, entry_details = 0
    batch = ACH::Batch.new
    bh = batch.header
    bh.company_name = 'Company Name'
    bh.company_identification = '123456789'
    bh.standard_entry_class_code = 'PPD'
    bh.company_entry_description = 'DESCRIPTION'
    bh.company_descriptive_date = Date.today
    bh.effective_entry_date =
      ACH::NextFederalReserveEffectiveDate.new(Date.today).result
    bh.originating_dfi_identification = '00000000'

    entry_details.times { add_detail_with_addenda(batch) }

    ach.batches << batch
  end

  def add_batch ach, entry_details = 0
    batch = ACH::Batch.new
    bh = batch.header
    bh.company_name = 'Company Name'
    bh.company_identification = '123456789'
    bh.standard_entry_class_code = 'PPD'
    bh.company_entry_description = 'DESCRIPTION'
    bh.company_descriptive_date = Date.today
    bh.effective_entry_date =
      ACH::NextFederalReserveEffectiveDate.new(Date.today).result
    bh.originating_dfi_identification = '00000000'

    entry_details.times { add_detail(batch) }

    ach.batches << batch
  end

  def add_detail batch
    ed = ACH::EntryDetail.new
    ed.transaction_code = ACH::CHECKING_CREDIT
    ed.routing_number = '000000000'
    ed.account_number = '00000000000'
    ed.amount = 100 # In cents
    ed.individual_id_number = 'Employee Name'
    ed.individual_name = 'Employee Name'
    ed.originating_dfi_identification = '00000000'
    ed.trace_number = 1
    batch.entries << ed
  end

  def add_detail_with_addenda batch
    ed = ACH::EntryDetail.new
    ed.transaction_code = ACH::CHECKING_CREDIT
    ed.routing_number = '000000000'
    ed.account_number = '00000000000'
    ed.amount = 100 # In cents
    ed.individual_id_number = 'Employee Name'
    ed.individual_name = 'Employee Name'
    ed.originating_dfi_identification = '00000000'
    ed.trace_number = 1

    addendum = ACH::Addendum.new
    addendum.payment_data = 'Sample Addendum'
    addendum.sequence_number = 1
    #further_credit_addendum.entry_detail_sequence_number = 1
    ed.addenda << addendum

    batch.entries << ed
  end

  describe '#to_s' do
    describe 'incrementing batch numbers' do
      before(:each) do
        add_batch ach_file, 1
        add_batch ach_file, 1
        add_batch ach_file, 1
      end

      context 'batch numbers not set' do
        it 'increments batch numbers' do
          lines = ach_file.to_s.split("\r\n")
          expect(lines[1][-1]).to eq('1')
          expect(lines[3][-1]).to eq('1')
          expect(lines[4][-1]).to eq('2')
          expect(lines[6][-1]).to eq('2')
          expect(lines[7][-1]).to eq('3')
          expect(lines[9][-1]).to eq('3')
        end
      end
    end

    describe 'padding with 9s' do
      let(:nines) { '9' * 94 }

      context 'number of records mod 10 is not 0 with addenda' do
        before(:each) do
          add_batch_with_addenda ach_file, 2 # 8 records total
        end

        it 'pads with 9s' do
          lines = ach_file.to_s.split("\r\n")

          expect(lines.length).to eq(10)

          lines[0..7].each do |line|
            expect(line).to_not eq(nines)
          end

          lines[8..9].each do |line|
            expect(line).to eq(nines)
          end

          add_batch ach_file, 5 # add 7 => 19 records total

          lines = ach_file.to_s.split("\r\n")
          expect(lines.length).to eq(20)

          lines[0..14].each do |line|
            expect(line).to_not eq(nines)
          end

          control_row = lines[14]
          expect(control_row[12]).to eq((lines.length / 10).ceil.to_s)

          lines[15..19].each do |line|
            expect(line).to eq(nines)
          end
        end
      end

      context 'number of records mod 10 is not 0' do
        before(:each) do
          add_batch ach_file, 3 # 7 records total
        end

        it 'pads with 9s' do
          lines = ach_file.to_s.split("\r\n")
          expect(lines.length).to eq(10)

          lines[0..6].each do |line|
            expect(line).to_not eq(nines)
          end

          lines[7..9].each do |line|
            expect(line).to eq(nines)
          end

          add_batch ach_file, 5 # add 7 => 14 records total

          lines = ach_file.to_s.split("\r\n")
          expect(lines.length).to eq(20)

          lines[0..13].each do |line|
            expect(line).to_not eq(nines)
          end

          control_row = lines[13]
          expect(control_row[12]).to eq((lines.length / 10).ceil.to_s)

          lines[14..19].each do |line|
            expect(line).to eq(nines)
          end
        end
      end

      context 'number of records mod 10 is 0' do
        before(:each) do
          add_batch ach_file, 6 # 7 records total
        end

        it 'does not pad with 9s' do
          lines = ach_file.to_s.split("\r\n")
          expect(lines.length).to eq(10)

          lines.each do |line|
            expect(line).to_not eq(nines)
          end

          add_batch ach_file, 8 # plus batch header and footer

          lines = ach_file.to_s.split("\r\n")
          expect(lines.length).to eq(20)

          control_row = lines[19]
          expect(control_row[12]).to eq((lines.length / 10).ceil.to_s)

          lines.each do |line|
            expect(line).to_not eq(nines)
          end
        end
      end
    end
  end
end
