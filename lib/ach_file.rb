# Require records files
require File.dirname(__FILE__) + '/records/field_identifiers.rb'
require File.dirname(__FILE__) + '/records/record.rb'

Dir[File.dirname(__FILE__) + '/records/*.rb'].each do |file|
  require file
end

module ACH 
  class ACHFile
    include FieldIdentifiers
    
    attr_reader :batches
    attr_reader :header
    attr_reader :control
    
    def initialize
      @batches = []
      @header = FileHeader.new
      @control = FileControl.new
    end
    
    def to_s
      records = []
      records << @header
      @batches.each { |b| records += b.to_ach }
      records << @control
      
      nines_needed = 10 - (records.length % 10)
      nines_needed = nines_needed % 10
      nines_needed.times { records << Nines.new() }
      
      @control.batch_count = @batches.length
      @control.block_count = (records.length / 10).ceil
      
      @control.entry_count = 0
      @control.debit_total = 0
      @control.credit_total = 0
      @control.entry_hash = 0
      
      @batches.each do | batch |
        @control.entry_count += batch.entries.length
        @control.debit_total += batch.control.debit_total
        @control.credit_total += batch.control.credit_total
        @control.entry_hash += batch.control.entry_hash
      end
      
      records.collect { |r| r.to_ach }.join("\n") + "\n"
    end
    
    def report
      to_s # To ensure correct records
      lines = []
      
      @batches.each do | batch |
        batch.entries.each do | entry |
          lines << left_justify(entry.individual_name + ": ", 25) +
              sprintf("% 7d.%02d", entry.amount / 100, entry.amount % 100)
        end
      end
      lines.join("\n")
    end
  end
end
