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
      
      def to_ach
        self.class.fields.collect { |f| send("#{f}_to_ach") }.join('').upcase
      end
    end
  end
end
