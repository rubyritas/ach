module ACH
  module Records
    class Record
      @fields = []

      class << self
        def fields
          @fields
        end
      end

      extend(FieldIdentifiers)

      attr_accessor :case_sensitive

      def to_ach eol: nil
        to_ach = self.class.fields.collect { |f| send("#{f}_to_ach") }.join('')
        case_sensitive ? to_ach : to_ach.upcase
      end

      # @return [Integer] Can override to include addenda count.
      def records_count
        1
      end
    end
  end
end
