module ACH::Records
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
    field :individual_name, String, lambda { |f| left_justify(f, 22)}
    field :discretionary_data, String, lambda { |f| left_justify(f, 2)}, '  '
    field :addenda_record_indicator, Integer,
        lambda { |f| sprintf('%01d', f)}, 0
    field :originating_dfi_identification, String,
        nil, nil, /\A\d{8}\z/
    field :trace_number, Integer, lambda { |f| sprintf('%07d', f)}, nil,
        lambda { |n| n.to_s.length <= 7 }

    def credit?
      CREDIT_RECORD_TRANSACTION_CODE_ENDING_DIGITS.include?(@transaction_code[1..1])
    end

    def debit?
      !credit?
    end

    def amount_value
      return self.amount
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


    attr_reader :addenda

    def initialize
      @addenda = []
    end

    def addenda_records?
      return !self.addenda.empty?
    end

    def to_ach
      self.addenda_record_indicator = (self.addenda.empty? ? 0 : 1)
      self.number_of_addenda_records = self.addenda.length

      ach_string = super

      self.addenda.each {|a|
        a.entry_detail_sequence_number = self.trace_number
        ach_string << "\r\n" + a.to_ach
      }
      return ach_string
    end

  end
end
