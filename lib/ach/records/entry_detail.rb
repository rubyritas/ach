module ACH::Records
  # PPD Entry Detail. Some other entry details, such as CCD, are close enough
  # to use this class. Version 1.x will have support for other types.
  class EntryDetail < Record
    CREDIT_RECORD_TRANSACTION_CODE_ENDING_DIGITS = ["0", "1", "2", "3", "4"]

    @fields = []

    attr_accessor :sorter

    const_field :record_type, '6'
    field :transaction_code, String,
        nil, nil, /\A\d{2}\z/
    spaceless_routing_field :routing_number # Receiving DFI Identification
                                            # and Check Digit
    field :account_number, String, lambda { |f| left_justify(f, 17)}
    field :amount, Integer, lambda { |f| sprintf('%010d', f)}
    field :individual_id_number, String, lambda { |f| left_justify(f, 15)}
    field :individual_name, String, lambda { |f| left_justify(f.gsub(/[\n\r]/, ''), 22)}
    field :discretionary_data, String, lambda { |f| left_justify(f, 2)}, '  '
    field :addenda_record_indicator, Integer,
        lambda { |f| sprintf('%01d', f)}, 0
    # There's not actually an originating DFI identification field for PPD
    # entries. Instead, it is suggested by the ACH spec that the ODFI be used
    # as the first 8 digits of the 15-digit trace number. I (Jared Morgan)
    # initially decided to treat the two elements of the trace number as
    # diffent fields, but that has caused confusion. I now intend to make this
    # an optional field which can used in generating the trace number, although
    # I haven't actually worked out how that will function.
    field :originating_dfi_identification, String,
        nil, nil, /\A\d{8}\z/
    field :trace_number, Integer, lambda { |f| sprintf('%07d', f)}, nil,
        lambda { |n| n.to_s.length <= 7 }

    attr_reader :addenda

    def initialize
      @addenda = []
    end

    def credit?
      CREDIT_RECORD_TRANSACTION_CODE_ENDING_DIGITS.include?(@transaction_code[1..1])
    end

    def debit?
      !credit?
    end

    def amount_value
      return self.amount
    end

    def addenda_records?
      return !self.addenda.empty?
    end

    def to_ach eol: ACH.eol
      self.addenda_record_indicator = (self.addenda.empty? ? 0 : 1) if self.respond_to?(:addenda_record_indicator)
      self.number_of_addenda_records = self.addenda.length if self.respond_to?(:number_of_addenda_records)

      ach_string = super

      self.addenda.each {|a|
        a.entry_detail_sequence_number = self.trace_number
        ach_string << eol + a.to_ach
      }
      return ach_string
    end

    # @return [Integer] Length of addenda plus 1, used by Batch#entry_count
    def records_count
      1 + self.addenda.length
    end
  end

  class CtxEntryDetail < EntryDetail
    @fields = EntryDetail.fields.slice(0, 6)
    field :number_of_addenda_records, Integer, lambda { |f| sprintf('%04d', f)}, 0
    field :individual_name, String, lambda { |f| left_justify(f, 16)}
    const_field :reserved, '  '
    field :discretionary_data, String, lambda { |f| left_justify(f, 2)}, '  '
    field :addenda_record_indicator, Integer,
        lambda { |f| sprintf('%01d', f)}
    field :originating_dfi_identification, String,
        nil, nil, /\A\d{8}\z/
    field :trace_number, Integer, lambda { |f| sprintf('%07d', f)}
  end

  class BalancingEntryDetail < EntryDetail
    @fields = EntryDetail.fields.slice(0, 5)
    const_field :individual_id_number, (' ' * 15)
    field :account_description, String, lambda { |f| left_justify(f, 22)}
    field :discretionary_data, String, lambda { |f| left_justify(f, 2)}, '  '
    field :addenda_record_indicator, Integer, lambda { |f| sprintf('%01d', f)}, 0
    field :origin_routing_number, String, lambda { |f| sprintf('%08d', f.to_i) }
    field :trace_number, Integer, lambda { |f| sprintf('%07d', f)}
  end 
end
