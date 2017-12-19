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
      
      attr_writer :case_sensitive

      def case_sensitive
        @case_sensitive.nil? ? true : @case_sensitive
      end
      
      def to_ach
        to_ach = self.class.fields.collect { |f| send("#{f}_to_ach") }.join('')
        case_sensitive ? to_ach : to_ach.upcase
      end

      def lines_count
        1
      end
    end
  end
end
