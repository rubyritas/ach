module ACH::Records
  class Addendum < Record

    # Notice of Change (NOC) Codes
    NOC_CODE_MAP = {
      'C01' => 'Incorrect DFI Account Number',
      'C02' => 'Incorrect Routing or Transit Number',
      'C03' => 'Incorrect Account Number and Incorrect Routing Transit Number',
      'C05' => 'Incorrect Transaction Code',
      'C06' => 'Incorrect DFI Account Number and Incorrect Transaction Code',
      'C07' => 'Incorrect Account Number, Incorrect Routing/Transit Number, and Incorrect Transaction Code',
      'C08' => 'Incorrect RDFI Identification (IAT only)',
      'C09' => 'Incorrect Individual Identification Number/Incorrect Receiver Identification Number',
      'C13' => 'Addenda Format Error',
      'C14' => 'Incorrect SEC Code for Outbound International Payment',
      'C61' => 'Misrouted NOC',
      'C62' => 'Incorrect Trace Number',
      'C63' => 'Incorrect Company Identification Number',
      'C64' => 'Incorrect Individual ID Number',
      'C65' => 'Corrected Data (incorrectly formatted)',
      'C66' => 'Incorrect Discretionary Data',
      'C67' => 'Routing Number (not from original entry detail record)',
      'C68' => 'DFI Account Number Not From Original Entry Detail Record',
      'C69' => 'Incorrect Transaction Code'
    }

    # Return Codes
    RETURN_CODE_MAP = {
      'R01' => 'Insufficient Funds',
      'R02' => 'Account Closed',
      'R03' => 'No Account or Unable to Locate',
      'R04' => 'Invalid Account Number',
      'R05' => 'Unauthorized Debit to Consumer Account using Corporate SEC Code',
      'R06' => "Returned per ODFI's Request",
      'R07' => 'Authorization Revoked by Customer',
      'R08' => 'Payment Stopped',
      'R09' => 'Uncollected Funds',
      'R10' => 'Customer Advises Not Authorized, Improper, or Ineligible',
      'R11' => 'Check Truncation Entry Returned',
      'R12' => 'Account Sold to Another DFI',
      'R13' => 'Invalid ACH Routing Number',
      'R14' => 'Representative Payee Deceased or Unable to Continue in that Capacity',
      'R15' => 'Beneficiary or Account Holder (Other than a Representative Payee) Deceased or Unable to Continue in that Capacity',
      'R16' => 'Account Frozen',
      'R17' => 'File Record Edit Criteria',
      'R18' => 'Improper Effective Entry Date',
      'R19' => 'Amount Field Error',
      'R20' => 'Non-Transaction Account',
      'R21' => 'Invalid Company Identification ',
      'R22' => 'Invalid Individual ID Number',
      'R23' => 'Credit Refused by Receiver',
      'R24' => 'Duplicate Entry ',
      'R25' => 'Addenda Error',
      'R26' => 'Mandatory Field Error',
      'R27' => 'Trace Number Error',
      'R28' => 'Routing Number Check Digit Error',
      'R29' => 'Corporate Customer Advises Not Authorized',
      'R30' => 'RDFI Not Participant in Check Truncation Program',
      'R31' => 'Permissible Return Entry',
      'R32' => 'RDFI Non-settlement',
      'R33' => 'Return of XCK entry ',
      'R34' => 'Limited Participation DFI',
      'R35' => 'Return of improper Debit entry',
      'R36' => 'Return of Improper Credit entry',
      'R37' => 'Source Document Presented for Payment',
      'R38' => 'Stop Payment on Source Document',
      'R39' => 'Improper Source Document',
      'R40' => 'Return of ENR Entry by Federal Government Agency',
      'R41' => 'Invalid transaction code',
      'R42' => 'Routing Number/Check Digit Error',
      'R43' => 'Invalid DFI Account Number',
      'R44' => 'Invalid Individual ID Number/identification Number',
      'R45' => 'Invalid Individual Name/Company Name',
      'R46' => 'Invalid Representative Payee Indicator',
      'R47' => 'Duplicate Enrollment (ENR Only)',
      'R50' => 'State law Affecting RCK Acceptance',
      'R51' => 'Item related to RCK Entry is Ineligible or RCK Entry is Improper',
      'R52' => 'Stop Payment on Item Related to RCK Entry',
      'R53' => 'Item and RCK Entry presented for Payment',
      'R61' => 'Misrouted Return',
      'R67' => 'Duplicate Return',
      'R68' => 'Untimely Return',
      'R69' => 'Field Error',
      'R70' => 'Permissible Return Entry Not Accepted/Return Not Requested by ODFI',
      'R71' => 'Misrouted Dishonored Return',
      'R72' => 'Untimely Dishonored Return',
      'R73' => 'Timely Original Return',
      'R74' => 'Corrected Return',
      'R75' => 'Return Not a Duplicate',
      'R76' => 'No Errors Found',
      'R80' => 'IAT Entry Coding Error',
      'R81' => 'Non-Participant in IAT Program',
      'R82' => 'Invalid Foreign RDFI Identification',
      'R83' => 'Foreign RDFI Unable to Settle',
      'R84' => 'Entry Not Processed by Gateway ',
      'R85' => 'Incorrectly Coded Outbound International Payment'
    }

    @fields = []

    const_field :record_type, '7'
    field :type_code, String, nil, '05', /\A\d{2}\z/
    field :payment_data, String, lambda { |f| left_justify(f, 80)}
    field :sequence_number, Integer, lambda { |f| sprintf('%04d', f)}
    field :entry_detail_sequence_number, Integer, lambda { |f| sprintf('%07d', f)}

    def reason_code
      payment_data[0..2]
    end

    def original_entry_trace_number
      payment_data[3..17]
    end

    def original_receiving_dfi_identification
      payment_data[24..31]
    end

    # NOTE: When the API can change, these subclasses should override the
    #       redundant fields in Addendum
    class NotificationOfChange < Addendum
      @fields = Addendum.fields

      def reason_description
        NOC_CODE_MAP[reason_code]
      end

      def corrected_data
        payment_data[32..60].strip
      end
    end

    class Return < Addendum
      @fields = Addendum.fields

      def reason_description
        RETURN_CODE_MAP[reason_code]
      end

      def date_of_death
        Date.parse(payment_data[18..23])
      end

      def addenda_information
        payment_data[32..75].strip
      end
    end
  end
end
