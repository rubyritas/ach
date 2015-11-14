module ACH
  module FieldTypes
    # Routing number (DFI Identification plus check digit).
    class RoutingNumber < Base
      self.default_length = 9

      attr_reader :identification, :check_digit

      # @param value [String]
      #   8-digit DFI Identification (routing number) or 9-digit number
      #   including check digit.
      def initialize value
        @identification = value.to_s
        if 9 == @identification.length
          @check_digit = @identification[-1]
          @identification = @identification[0..7]
        else
          @check_digit = calculate_check_digit.to_s
        end
        valid?
      end

      WEIGHTS = [3, 7, 1, 3, 7, 1, 3, 7, 1]

      # Calculate the check digit.
      #
      # @return [Integer]
      def calculate_check_digit
        return nil unless @identification =~ /\A\d{8}\Z/
        sum = 0
        @identification.each_char.each_with_index do |digit, index|
          sum += digit.to_i * WEIGHTS[index]
        end
        (10 - (sum % 10)) % 10
      end

      # @return [String]
      #   Value to use in ACH file. DFI Identification (8 digits) plus check
      #   digit.
      def ach
        "#{@identification}#{@check_digit}"
      end

      # @see Base#invalid!
      #
      # Validation checks:
      # - DFI Identification must be 8 digits.
      # - Check digit, if given, must match claculated check digit (only checked
      #   if DFI Identification is valid as otherwise the check digit is not
      #   meaningful).
      #
      # @return [true, false]
      def valid?
        valid = true

        if @identification !~ /\A\d{8}\Z/
          invalid! 'must be 8 digits long (or 9 digits if including the check digit)'
          valid = false
        elsif calculate_check_digit.to_s != @check_digit
          invalid! "check digit (#{@check_digit}) does not match expected value (#{calculate_check_digit.to_s})"
          valid = false
        end

        valid
      end
    end
  end
end
