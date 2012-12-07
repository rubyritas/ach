require 'example_helper'
require 'date'

describe "Parse" do
  describe 'Returns and NOC' do
    before(:each) do
      @data = File.read('examples/ach/fixtures/return_noc.txt')
    end

    it "should parse return/notification of change file" do
      ach = ACH::ACHFile.new(@data)
      fh = ach.header
      fh.immediate_destination.should == "191001234"
      fh.immediate_origin.should == "992222226"
      fh.transmission_datetime.should == Time.utc(2012, 10, 15, 15, 18)
      fh.immediate_destination_name.should == "Certification Bank-Sili"
      fh.immediate_origin_name.should == "CERTIFICATION BANK-SILI"

      ach.batches.size.should == 3

      batch = ach.batches[0]
      batch.entries.size.should == 1
      bh = batch.header
      bh.company_name.should == "COMPANY INC"
      bh.company_identification.should == "412345678"
      bh.standard_entry_class_code.should == 'COR'
      bh.company_entry_description.should == "DESCRIPT"
      bh.company_descriptive_date.should == Date.parse('121015')
      bh.effective_entry_date.should == Date.parse('121015')
      bh.originating_dfi_identification.should == "99222222"

      ed = batch.entries[0]
      ed.transaction_code.should == "21"
      ed.routing_number.should == "121140399"
      ed.account_number.should == "3300911569"
      ed.amount.should == 0 # In cents
      ed.individual_id_number.should == "A38LTNY2"
      ed.individual_name.should == "NAME ONE"

      ed.addenda.size.should == 1
      ad = ed.addenda[0]
      ad.type_code.should == '98'
      ad.payment_data.should =~ /^C05/
      ad.sequence_number.should == 4039

      batch = ach.batches[1]
      batch.entries.size.should == 1
      bh = batch.header
      bh.standard_entry_class_code.should == 'PPD'
      ed = batch.entries[0]
      ed.amount.should == 2536
    end

  end
end
