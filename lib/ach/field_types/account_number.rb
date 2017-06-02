module ACH
  module FieldTypes
    # DFI Account Number.
    class AccountNumber < Base
      self.default_length = 17

      attr_reader :value

      # @param value [String]
      #   DFI Account Number (17 positions for most records, 15 for ACK). Spaces
      #   are removed and value is truncated to the maximum length for the
      #   record.
      def initialize value, record_options = {}
        @length = record_options[:length] || self.class.default_length
        @value = value.to_s.gsub(/\s+/, '')
        valid?
      end

      # @return [String]
      #   @value prepending with spaces or truncated to @length (17 for most
      #   records, 15 for ACK).
      def ach
        left_justify @value[0..@length], @length
      end
    end
  end
end
