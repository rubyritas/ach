module ACH
  module FieldTypes
    class Base
      # @param value [String]
      def initialize value
        @value = value
      end

      # @return [String] Field value for use in ACH file.
      def ach
        @value
      end

      # Run validation checks. Failures should call #invalid! and return false.
      # The default implementation of #invalid raises an error, but this will
      # probably become configurable at some point.
      #
      # The Base class does not have any validation rules and thus always
      # returns true.
      #
      # @return [true,false] Whether value is valid.
      def valid?
        true
      end

      # Called when the field is invalid.
      #
      # @param message [String] description of error.
      # @raise [InvalidError]
      def invalid! message
        raise InvalidError, "#{self.class.name} (#{self.ach}) #{message}."
      end

      private

      # Left justify value with spaces and truncate to length if needed.
      #
      # @param value [String] String to be truncated.
      # @param positions [Integer] Positions this field should take in ACH file.
      def left_justify value, positions
        value[0..(positions - 1)].ljust positions
      end

      class << self
        # Default length of field, used in parsing, and #ach methods.
        attr_accessor :default_length

        # Parse the given value. By default, this just creates a new instance
        # using the value provided.
        #
        # @param value [String] Value to parse.
        def parse value
          new value
        end
      end
    end
  end
end
