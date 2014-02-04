module ACH
  class Batch
    attr_reader :entries
    attr_reader :addendas
    attr_reader :header
    attr_reader :control
    
    def initialize
      @entries = []
      @addendas = []
      @header = Records::BatchHeader.new
      @control = Records::BatchControl.new
    end

    def to_ach(batch_number)
      @control.entry_count  = @entries.length
      @control.entry_hash   = 0
      @control.debit_total  = 0.00
      @control.credit_total = 0.00
      has_debits            = false
      has_credits           = false
      
      @entries.each do |e|
        e.populate_check_digit
        e.debit? ? @control.debit_total += e.amount : @control.credit_total += e.amount
        @control.entry_hash             += (e.routing_number.to_i / 10)
      end

      has_debits  = true if @control.debit_total  != 0.00
      has_credits = true if @control.credit_total != 0.00

      @control.debit_total  = (@control.debit_total  * 100).to_i
      @control.credit_total = (@control.credit_total * 100).to_i
      
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
      
      @control.company_identification              = @header.company_identification
      @control.originating_dfi_identification      = @header.originating_dfi_identification
      @header.batch_number = @control.batch_number = batch_number
      
      [@header] + @entries + @addendas + [@control]
    end
  end
end
