module ACH
  class Batch
    attr_reader :entries
    attr_reader :addendas
    attr_reader :header
    attr_reader :control
    attr_accessor :full_company_identification

    def initialize
      @entries = []
      @addendas = []
      @header = Records::BatchHeader.new
      @control = Records::BatchControl.new
    end

    def to_ach
      @control.entry_count = @entries.map(&:records_count).reduce(:+).to_i
      @control.debit_total = 0
      @control.credit_total = 0
      @control.entry_hash = 0
      has_debits = false
      has_credits = false

      @entries.each do |e|
        if e.debit?
          @control.debit_total += e.amount
          has_debits = true
        else
          @control.credit_total += e.amount
          has_credits = true
        end
        @control.entry_hash +=
            (e.routing_number.to_i / 10) # Last digit is not part of Receiving DFI
      end

      # Set service class codes if needed
      if @header.service_class_code.nil?
        if has_debits && has_credits
          @header.service_class_code = 200
        elsif has_debits
          @header.service_class_code = 225
        else
          @header.service_class_code = 220
        end
      end

      if @control.service_class_code.nil?
        @control.service_class_code = @header.service_class_code
      end

      @control.company_identification = @header.company_identification
      @control.originating_dfi_identification = @header.originating_dfi_identification
      @control.batch_number = @header.batch_number
      if last_entry.is_a? ACH::BalancingEntryDetail
        @control.credit_total = last_entry.amount
        @control.debit_total = last_entry.amount
      end

      [@header] + @entries + @addendas + [@control]
    end

    private

    def last_entry
      @last_entry ||= @entries.last
    end
  end
end
