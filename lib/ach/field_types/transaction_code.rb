module ACH
  module FieldTypes
    # Transaction Code, which is a two-digit String identifying the type of
    # credit or debit entry. For example: '22' is a 'Demand (Checking) Credit'.
    class TransactionCode < Base

      # Incomplete list of possible codes, used in #description. NB: This list
      # is not currently used by #valid?
      CODES = {
        # Demand (Checking, NOW, share draft)
        '22' => 'Demand Credit',
        '23' => 'Prenotification of Demand Credit',
        '24' => 'Zero dollar with remittance data',
        '27' => 'Demand Debit',
        '28' => 'Prenotification of Demand Debit',
        '29' => 'Zero dollar with remittance data',

        # Savings
        '32' => 'Savings Credit',
        '33' => 'Prenotification of Savings Credit',
        '34' => 'Zero dollar with remittance data',
        '37' => 'Savings Debit',
        '38' => 'Prenotification of Savings Debit',
        '39' => 'Zero dollar with remittance data',

        # Loan Account
        '52' => 'Loan Account Credit',
        '53' => 'Prenotification of Loan Account Credit',
        '54' => 'Zero dollar with remittance data',
        '55' => 'Loan Account Debit'
      }

      attr_reader :value

      # @param value [~to_s]
      #   Two-digit String identifying the type of the credit or debit entry.
      def initialize value
        @value = value.to_s
        valid?
      end

      # @return [String] Description of code, if available.
      def description
        CODES[@value] || "Transaction Code #{@value}"
      end

      # Validate that value is a String consisting of exactly two digits.
      #
      # @return [true, false]
      def valid?
        valid = true

        if @value !~ /\A\d{2}\Z/
          invalid! 'must consist of exactly two digits'
          valid = false
        end

        valid
      end
    end
  end
end
