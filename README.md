# ACH

ACH is a Ruby helper for building and parsing ACH files.

In particular, it helps with field
order and alignment, and adds padding lines to end of file.

## Example

You should consult a copy of the [ACH Rules](http://www.nacha.org) for details
on individual fields. You can probably obtain a copy from your bank.

```ruby
require 'ach'

# Create ACH file
ach = ACH::ACHFile.new
trace_number = 0

# File Header
fh = ach.header
fh.immediate_destination = '000000000'
fh.immediate_destination_name = 'BANK NAME'
fh.immediate_origin = '000000000'
fh.immediate_origin_name = 'BANK NAME'
# Optional - This value is used in the File Creation Date/Time attributes - if excluded will default to Time.now
# Note that you may wish to modify the time zone here if your environment has a different time zone than the banks
# For example if your server is in UTC and the bank's is in US/Eastern, any files sent after 8pm Eastern/Midnight UTC
#   would have a File Creation Date of the next day from the bank's perspective
fh.transmission_datetime = Time.now

# Batch
batch = ACH::Batch.new
bh = batch.header
bh.company_name = 'Company Name'
bh.company_identification = '123456789' # Use 10 characters if you're not using an EIN
bh.standard_entry_class_code = 'PPD'
bh.company_entry_description = 'DESCRIPTION'
bh.company_descriptive_date = Date.today # Or string with 'SDHHMM' for same day ACH
bh.effective_entry_date = ACH::NextFederalReserveEffectiveDate.new(Date.today).result
bh.originating_dfi_identification = '00000000'
ach.batches << batch

# Detail Entry
ed = ACH::EntryDetail.new
ed.transaction_code = ACH::CHECKING_CREDIT
ed.routing_number = '000000000'
ed.account_number = '00000000000'
ed.amount = 100 # In cents
ed.individual_id_number = 'Employee Name'
ed.individual_name = 'Employee Name'
ed.originating_dfi_identification = '00000000'
batch.entries << ed
# ... Additional detail entries, possibly including *offsetting entry*, if needed.

# Insert trace numbers
batch.entries.each.with_index(1) { |entry, index| entry.trace_number = index }


File.write('ach.txt', ach.to_s)

p ach.report
```

```ruby
# Parse an ACH file
ach = ACH::ACHFile.new(File.read('examples/ach/fixtures/return_noc.txt'))
ach.batches.first.entries.first.addenda.first.payment_data
=> "C05992222220280489      1211403932                                          1211"
```

**Note:** When adding an amount to your ach file, it needs to be in cents. So you'll want to multiply any dollar amounts by 100

## Copyright

Copyright (c) 2008-2009 Jared E Morgan, released under the MIT license
