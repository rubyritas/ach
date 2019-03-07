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

          lines[14..19].each do |line|
            expect(line).to eq(nines)
          end
        end

        context 'has addendum records' do
          it 'accounts for addendum records' do
            addendum = ACH::Addendum.new
            addendum.sequence_number = 1
            addendum.payment_data = 'Data'

            ach_file.batches.first.entries.last.addenda << addendum
            lines = ach_file.to_s.split("\r\n")
            p lines
            expect(lines.length).to eq(10)

            lines[0..7].each do |line|
              expect(line).to_not eq(nines)
            end

            lines[8..9].each do |line|
              expect(line).to eq(nines)
            end
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

          lines.each do |line|
            expect(line).to_not eq(nines)
          end
        end
      end
    end

    describe 'eol param' do
      context 'default' do
        subject(:output) { ach_file.to_s }

        it 'uses CRLF' do
          expect(output.split("\r\n").length).to eq(10)
          expect(output[-2..-1]).to eq("\r\n")
        end
      end

      context 'param given' do
        subject(:output) { ach_file.to_s("\n") }
        it 'uses the param' do
          expect(output.split("\r\n").length).to eq(1)
          expect(output.split("\n").length).to eq(10)
          expect(output[-2..-1]).to_not eq("\r\n")
          expect(output[-1]).to eq("\n")
        end
      end
    end
  end
end
