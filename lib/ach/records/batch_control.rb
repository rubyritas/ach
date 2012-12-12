module ACH::Records
  class BatchControl < Record
    @fields = []

    const_field :record_type, '8'

    # TODO: many of the fields are calculated in Batch.to_ach, so the defaults
    #       should be removed
    field :service_class_code, String,
        lambda { |f| f.to_s }, '200',
        lambda { |f| ACH::SERVICE_CLASS_CODES.include?(f.to_i) }
    field :entry_count, Integer, lambda { |f| sprintf('%06d', f)}
    field :entry_hash, Integer, lambda { |f| sprintf('%010d', f % (10 ** 10))}
    field :debit_total, Integer, lambda { |f| sprintf('%012d', f)}
    field :credit_total, Integer, lambda { |f| sprintf('%012d', f)}
    field :company_identification_code_designator, String, nil, '1',
        /\A[0-9 ]\z/
    field :company_identification, String,
        nil, nil, /\A\d{9}\z/

    field :message_authentication_code, String,
        lambda { |f| left_justify(f, 19)}, ''

    const_field :reserved, (' ' * 6)

    field :originating_dfi_identification, String,
        nil, nil, /\A\d{8}\z/

    field :batch_number, Integer, lambda { |f| sprintf('%07d', f)}, 1
  end
end
