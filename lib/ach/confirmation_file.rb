# Confirmation files should be read from data only.
# We will never create them as they are generated in
# response to NACHA file uploads.
require "date"

module ACH
  class ConfirmationFile
    include FieldIdentifiers

    attr_reader :batches
    attr_reader :header
    attr_reader :control

    def initialize data=nil
      @batches = []
      @header = Records::FileHeader.new
      @control = Records::FileControlConfirmation.new

      if data
        if (data.encode(Encoding.find("ASCII"),ENCODING_OPTIONS) =~ /\n|\r\n/).nil?
          parse_fixed(data)
        else
          parse(data)
        end
      end
    end

    def to_s
      records = []
      records << @header
      @batches.each { |b| records += b.to_ach }
      records << @control

      records.collect { |r| r.to_ach }.join("\r\n") + "\r\n"
    end

    def parse_fixed data
      # replace with a space to preserve the record-lengths
      encoded_data = data.encode(Encoding.find("ASCII"),
                                 { :invalid => :replace, :undef => :replace, :replace => " " })
      parse encoded_data.scan(/.{94}/).join("\n")
    end

    def parse data
      fh = self.header
      fc = self.control
      batch = nil

      data.strip.split(/\n|\r\n/).each do |line|
        type = line[0].chr
        case type
          when "1"
            fh.immediate_destination          = line[03..12].strip
            fh.immediate_origin               = line[13..22].strip
            fh.transmission_datetime          = Time.utc("20"+line[23..24], line[25..26],
                                                         line[27..28], line[29..30], line[31..32])
            fh.file_id_modifier               = line[33..33]
            fh.immediate_destination_name     = line[40..62].strip
            fh.immediate_origin_name          = line[63..85].strip
            fh.reference_code                 = line[86..93].strip
          when "5"
            self.batches << batch unless batch.nil?
            batch = ACH::Batch.new
            bh = batch.header
            bh.company_name                   = line[4..19].strip
            bh.company_identification         = line[40..49].gsub(/\A1/, "")
            bh.standard_entry_class_code      = line[50..52].strip
            bh.company_entry_description      = line[53..62].strip
            bh.company_descriptive_date       = Date.parse(line[63..68]) rescue nil
            bh.effective_entry_date           = Date.parse(line[69..74])
            bh.originating_dfi_identification = line[79..86].strip
            bh.batch_number                   = line[87..93].to_i
          when "8"
            # skip
          when "9"
            fc.batch_count                    = line[1..6].to_i
            fc.block_count                    = line[7..12].to_i
            fc.entry_count                    = line[13..20].to_i
            fc.entry_hash                     = line[21..30].to_i
            fc.debit_total                    = line[31..42].to_i # cents
            fc.credit_total                   = line[43..54].to_i # cents
            fc.message_codes                  = line[56..61]
          else
            raise "Didn't recognize type code #{type} for this line:\n#{line}"
        end
      end

      self.batches << batch unless batch.nil?
      to_s
    end
  end
end
