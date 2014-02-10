module ACH::Records
  class EntryDetail < Record
    CREDIT_RECORD_TRANSACTION_CODE_ENDING_DIGITS = ["0", "1", "2", "3", "4"]
    CHECK_DIGIT_WEIGHTS                          = [3, 7, 1, 3, 7, 1, 3, 7]

    @fields = []

    attr_accessor :sorter

    const_field :record_type, '6'
    field :transaction_code, String,
        nil, nil, /\A\d{2}\z/
    field :routing_number, String, lambda { |f| f.rjust(8, '0') }
    field :check_digit, Integer, lambda { |f| sprintf('%01d', f)}, 0
    field :account_number, String, lambda { |f| f.rjust(17, '0') }
    field :amount, Integer, lambda { |f| sprintf('%010d', (f * 100).to_s.rjust(10, '0').to_i) }
    field :individual_id_number, String, lambda { |f| f.to_s.rjust(15, '0') }
    field :individual_name, String, lambda { |f| left_justify(f, 22)}
    field :discretionary_data, String, lambda { |f| left_justify(f, 2)}, '  '
    field :addenda_record_indicator, Integer,
        lambda { |f| sprintf('%01d', f)}, 0
    field :trace_number, Integer, lambda { |f| sprintf('%015d', f)}, nil,
        lambda { |n| n.to_s.length <= 15 }

    def credit?
      CREDIT_RECORD_TRANSACTION_CODE_ENDING_DIGITS.include?(@transaction_code[1..1])
    end

    def debit?
      !credit?
    end

    def amount_value
      return self.amount
    end

    # Per NACHA 2013 Operating Rules, page 104.
    def populate_check_digit
      weighted_sum = routing_number.to_s.rjust(8, '0').split(//).map(&:to_i).zip(CHECK_DIGIT_WEIGHTS).map{ |i,j| i * j }.inject(:+)
      nearest_multiple_of_ten  = weighted_sum.round(-1)
      nearest_multiple_of_ten += 10 if nearest_multiple_of_ten < weighted_sum
      self.check_digit         = nearest_multiple_of_ten - weighted_sum
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
    field :trace_number, Integer, lambda { |f| sprintf('%15d', f)}


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
