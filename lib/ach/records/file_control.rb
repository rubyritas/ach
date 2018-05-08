module ACH::Records
  class FileControl < Record
    @fields = []

    const_field :record_type, '9'
    # Many of the fields are calculated in ACHFile.to_ach
    field :batch_count, Integer, lambda { |f| sprintf('%06d', f)}
    field :block_count, Integer, lambda { |f| sprintf('%06d', f)}
    field :entry_count, Integer, lambda { |f| sprintf('%08d', f)}
    field :entry_hash, Integer, lambda { |f| sprintf('%010d', f % (10 ** 10))}

    field :debit_total, Integer, lambda { |f| sprintf('%012d', f)}
    field :credit_total, Integer, lambda { |f| sprintf('%012d', f)}

    field :filler, String, lambda { |f| left_justify(f, 39)}, ' '
  end
end

