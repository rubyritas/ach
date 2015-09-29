module ACH::Records
  class FileControlConfirmation < Record
    @fields = []

    const_field :record_type, "9"
    field :batch_count, Integer, lambda { |f| sprintf("%06d", f) }
    field :block_count, Integer, lambda { |f| sprintf("%06d", f) }
    field :entry_count, Integer, lambda { |f| sprintf("%08d", f) }
    field :entry_hash, Integer, lambda { |f| sprintf("%010d", f % (10 ** 10)) }

    field :debit_total, Integer, lambda { |f| sprintf("%012d", f) }
    field :credit_total, Integer, lambda { |f| sprintf("%012d", f) }
    const_field :spacer, " "
    field :message_codes, String, lambda { |f| left_justify(f, 6) }
    const_field :reserved, (" " * 32)
  end
end

