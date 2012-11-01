#ACH

ach is a Ruby helper for builder ACH files. In particular, it helps with field
order and alignment, and adds padding lines to end of file.

**This library has only been used in one production application and for very
limited purposes. Please test thoroughly before using in a production 
environment.**

See [ACH::Builder](http://search.cpan.org/~tkeefer/ACH-Builder-0.03/lib/ACH/Builder.pm)
for a similar Perl library

##Example

You should consult a copy of the [ACH Rules](http://www.nacha.org) for details
on individual fields. You can probably obtain a copy from your bank.

```ruby
# Create ACH file
ach = ACH::ACHFile.new
trace_number = 0

# File Header
fh = ach.header
fh.immediate_destination = "000000000"
fh.immediate_destination_name = "BANK NAME"
fh.immediate_origin = "000000000"
fh.immediate_origin_name = "BANK NAME"

# Batch
batch = ACH::Batch.new
bh = batch.header
bh.company_name = "Company Name"
bh.company_identification = "123456789"
bh.standard_entry_class_code = 'PPD'
bh.company_entry_description = "DESCRIPTION"
bh.company_descriptive_date = Date.today
bh.effective_entry_date = (Date.today + 1)
bh.originating_dfi_identification = "00000000"
ach.batches << batch

# Detail Entry
ed = ACH::EntryDetail.new
ed.transaction_code = ACH::CHECKING_CREDIT
ed.routing_number = "000000000"
ed.account_number = "00000000000"
ed.amount = 100 # In cents
ed.individual_id_number = "Employee Name"
ed.individual_name = "Employee Name"
ed.originating_dfi_identification = '00000000'
batch.entries << ed
# ... Additional detail entries, possibly including *offsetting entry*, if needed.

# Insert trace numbers
batch.entries.each{ |entry| entry.trace_number = (trace_number += 1) }


output = ach.to_s
File.open("ach.txt", 'w') do |f|
  f.write output
end

p ach.report
```

```ruby
# Parse an ACH file
ach = ACH::ACHFile.new(File.read('examples/ach/fixtures/return_noc.txt'))
ach.batches.first.entries.first.addenda.first.payment_data
=> "C05992222220280489      1211403932                                          1211"
```

##Copyright

Copyright (c) 2008-2009 Jared E Morgan, released under the MIT license
